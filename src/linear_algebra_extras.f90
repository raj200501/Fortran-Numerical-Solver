module linear_algebra_extras
    use kinds, only: dp
    use errors, only: require
    implicit none
contains
    subroutine gram_schmidt(A, Q, R)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:,:), intent(out) :: Q, R
        integer :: m, n, i, j
        real(dp) :: norm_val
        real(dp), allocatable :: v(:)

        m = size(A,1)
        n = size(A,2)
        call require(size(Q,1) == m .and. size(Q,2) == n, 'gram_schmidt: Q size mismatch')
        call require(size(R,1) == n .and. size(R,2) == n, 'gram_schmidt: R size mismatch')

        Q = 0.0_dp
        R = 0.0_dp
        allocate(v(m))
        do j = 1, n
            v = A(:,j)
            do i = 1, j-1
                R(i,j) = dot_product(Q(:,i), A(:,j))
                v = v - R(i,j) * Q(:,i)
            end do
            norm_val = sqrt(dot_product(v, v))
            call require(norm_val > 0.0_dp, 'gram_schmidt: dependent columns')
            R(j,j) = norm_val
            Q(:,j) = v / norm_val
        end do
        deallocate(v)
    end subroutine gram_schmidt

    subroutine qr_solve(A, b, x)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:), intent(in) :: b
        real(dp), dimension(:), intent(out) :: x
        integer :: m, n, i, j
        real(dp), allocatable :: Q(:,:), R(:,:), y(:)

        m = size(A,1)
        n = size(A,2)
        call require(size(b) == m, 'qr_solve: b size mismatch')
        call require(size(x) == n, 'qr_solve: x size mismatch')

        allocate(Q(m,n), R(n,n), y(n))
        call gram_schmidt(A, Q, R)
        y = matmul(transpose(Q), b)
        do i = n, 1, -1
            x(i) = y(i)
            do j = i+1, n
                x(i) = x(i) - R(i,j) * x(j)
            end do
            call require(R(i,i) /= 0.0_dp, 'qr_solve: zero diagonal')
            x(i) = x(i) / R(i,i)
        end do
        deallocate(Q, R, y)
    end subroutine qr_solve

    subroutine power_iteration(A, x, max_iter, tol, eigenvalue, iterations, converged)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:), intent(inout) :: x
        integer, intent(in) :: max_iter
        real(dp), intent(in) :: tol
        real(dp), intent(out) :: eigenvalue
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp), allocatable :: y(:)
        real(dp) :: norm_val, lambda_old
        integer :: n

        n = size(A,1)
        call require(size(A,2) == n, 'power_iteration: A not square')
        call require(size(x) == n, 'power_iteration: x size mismatch')

        allocate(y(n))
        eigenvalue = 0.0_dp
        lambda_old = 0.0_dp
        converged = .false.
        do iterations = 1, max_iter
            y = matmul(A, x)
            norm_val = sqrt(dot_product(y, y))
            call require(norm_val /= 0.0_dp, 'power_iteration: zero vector')
            x = y / norm_val
            eigenvalue = dot_product(x, matmul(A, x))
            if (abs(eigenvalue - lambda_old) < tol) then
                converged = .true.
                exit
            end if
            lambda_old = eigenvalue
        end do
        deallocate(y)
    end subroutine power_iteration
end module linear_algebra_extras
