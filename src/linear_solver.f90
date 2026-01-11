module linear_solver
    use kinds, only: dp
    use errors, only: require
    use matrix_operations, only: lu_factor, forward_substitution, backward_substitution, vector_norm2, vector_dot
    implicit none
contains
    subroutine solve_linear_system(A, b, x, info)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:), intent(in) :: b
        real(dp), dimension(:), intent(out) :: x
        integer, intent(out) :: info
        real(dp), allocatable :: L(:,:), U(:,:), y(:)
        integer, allocatable :: piv(:)
        integer :: n
        n = size(A,1)
        call require(size(A,2) == n, 'solve_linear_system: A not square')
        call require(size(b) == n, 'solve_linear_system: b size mismatch')
        call require(size(x) == n, 'solve_linear_system: x size mismatch')

        allocate(L(n,n), U(n,n), y(n), piv(n))
        call lu_factor(A, L, U, piv, info)
        if (info /= 0) then
            x = 0.0_dp
            deallocate(L, U, y, piv)
            return
        end if
        call apply_pivot(b, piv, y)
        call forward_substitution(L, y, y)
        call backward_substitution(U, y, x)
        deallocate(L, U, y, piv)
    end subroutine solve_linear_system

    subroutine apply_pivot(b, piv, bp)
        real(dp), dimension(:), intent(in) :: b
        integer, dimension(:), intent(in) :: piv
        real(dp), dimension(:), intent(out) :: bp
        integer :: n, i
        n = size(b)
        call require(size(piv) == n, 'apply_pivot: size mismatch')
        call require(size(bp) == n, 'apply_pivot: output size mismatch')
        do i = 1, n
            bp(i) = b(piv(i))
        end do
    end subroutine apply_pivot

    subroutine jacobi_solver(A, b, x, max_iter, tol, iterations, converged)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:), intent(in) :: b
        real(dp), dimension(:), intent(inout) :: x
        integer, intent(in) :: max_iter
        real(dp), intent(in) :: tol
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        integer :: n, i, j
        real(dp) :: sigma, diff
        real(dp), allocatable :: x_new(:)

        n = size(A,1)
        call require(size(A,2) == n, 'jacobi_solver: A not square')
        call require(size(b) == n .and. size(x) == n, 'jacobi_solver: size mismatch')

        allocate(x_new(n))
        converged = .false.
        do iterations = 1, max_iter
            do i = 1, n
                sigma = 0.0_dp
                do j = 1, n
                    if (j /= i) sigma = sigma + A(i,j) * x(j)
                end do
                call require(A(i,i) /= 0.0_dp, 'jacobi_solver: zero diagonal element')
                x_new(i) = (b(i) - sigma) / A(i,i)
            end do
            diff = vector_norm2(x_new - x)
            x = x_new
            if (diff < tol) then
                converged = .true.
                exit
            end if
        end do
        deallocate(x_new)
    end subroutine jacobi_solver

    subroutine gauss_seidel_solver(A, b, x, max_iter, tol, iterations, converged)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:), intent(in) :: b
        real(dp), dimension(:), intent(inout) :: x
        integer, intent(in) :: max_iter
        real(dp), intent(in) :: tol
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        integer :: n, i, j
        real(dp) :: sigma, diff
        real(dp), allocatable :: x_old(:)

        n = size(A,1)
        call require(size(A,2) == n, 'gauss_seidel_solver: A not square')
        call require(size(b) == n .and. size(x) == n, 'gauss_seidel_solver: size mismatch')

        allocate(x_old(n))
        converged = .false.
        do iterations = 1, max_iter
            x_old = x
            do i = 1, n
                sigma = 0.0_dp
                do j = 1, n
                    if (j /= i) sigma = sigma + A(i,j) * x(j)
                end do
                call require(A(i,i) /= 0.0_dp, 'gauss_seidel_solver: zero diagonal element')
                x(i) = (b(i) - sigma) / A(i,i)
            end do
            diff = vector_norm2(x - x_old)
            if (diff < tol) then
                converged = .true.
                exit
            end if
        end do
        deallocate(x_old)
    end subroutine gauss_seidel_solver

    subroutine conjugate_gradient_solver(A, b, x, max_iter, tol, iterations, converged)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:), intent(in) :: b
        real(dp), dimension(:), intent(inout) :: x
        integer, intent(in) :: max_iter
        real(dp), intent(in) :: tol
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp), allocatable :: r(:), p(:), Ap(:)
        real(dp) :: alpha, beta, rs_old, rs_new
        integer :: n

        n = size(A,1)
        call require(size(A,2) == n, 'conjugate_gradient_solver: A not square')
        call require(size(b) == n .and. size(x) == n, 'conjugate_gradient_solver: size mismatch')

        allocate(r(n), p(n), Ap(n))
        r = b - matmul(A, x)
        p = r
        rs_old = vector_dot(r, r)
        converged = .false.
        do iterations = 1, max_iter
            Ap = matmul(A, p)
            alpha = rs_old / vector_dot(p, Ap)
            x = x + alpha * p
            r = r - alpha * Ap
            rs_new = vector_dot(r, r)
            if (sqrt(rs_new) < tol) then
                converged = .true.
                exit
            end if
            beta = rs_new / rs_old
            p = r + beta * p
            rs_old = rs_new
        end do
        deallocate(r, p, Ap)
    end subroutine conjugate_gradient_solver
end module linear_solver
