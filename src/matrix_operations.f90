module matrix_operations
    use kinds, only: dp
    use errors, only: require
    implicit none
contains
    subroutine matrix_multiply(A, B, C)
        real(dp), dimension(:,:), intent(in) :: A, B
        real(dp), dimension(:,:), intent(out) :: C
        integer :: n, m, k

        n = size(A, 1)
        k = size(A, 2)
        m = size(B, 2)
        call require(k == size(B,1), 'matrix_multiply: incompatible shapes')
        call require(size(C,1) == n .and. size(C,2) == m, 'matrix_multiply: output shape mismatch')

        C = matmul(A, B)
    end subroutine matrix_multiply

    subroutine matrix_transpose(A, AT)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:,:), intent(out) :: AT
        call require(size(AT,1) == size(A,2) .and. size(AT,2) == size(A,1), 'matrix_transpose: output shape mismatch')
        AT = transpose(A)
    end subroutine matrix_transpose

    function vector_dot(a, b) result(res)
        real(dp), dimension(:), intent(in) :: a, b
        real(dp) :: res
        call require(size(a) == size(b), 'vector_dot: size mismatch')
        res = sum(a * b)
    end function vector_dot

    function vector_norm2(a) result(res)
        real(dp), dimension(:), intent(in) :: a
        real(dp) :: res
        res = sqrt(sum(a * a))
    end function vector_norm2

    subroutine identity_matrix(I)
        real(dp), dimension(:,:), intent(out) :: I
        integer :: n, i
        n = size(I,1)
        call require(n == size(I,2), 'identity_matrix: not square')
        I = 0.0_dp
        do i = 1, n
            I(i,i) = 1.0_dp
        end do
    end subroutine identity_matrix

    subroutine matrix_add(A, B, C)
        real(dp), dimension(:,:), intent(in) :: A, B
        real(dp), dimension(:,:), intent(out) :: C
        call require(size(A,1) == size(B,1) .and. size(A,2) == size(B,2), 'matrix_add: size mismatch')
        call require(size(C,1) == size(A,1) .and. size(C,2) == size(A,2), 'matrix_add: output size mismatch')
        C = A + B
    end subroutine matrix_add

    subroutine matrix_subtract(A, B, C)
        real(dp), dimension(:,:), intent(in) :: A, B
        real(dp), dimension(:,:), intent(out) :: C
        call require(size(A,1) == size(B,1) .and. size(A,2) == size(B,2), 'matrix_subtract: size mismatch')
        call require(size(C,1) == size(A,1) .and. size(C,2) == size(A,2), 'matrix_subtract: output size mismatch')
        C = A - B
    end subroutine matrix_subtract

    function matrix_trace(A) result(trace_val)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp) :: trace_val
        integer :: n, i
        n = size(A,1)
        call require(n == size(A,2), 'matrix_trace: not square')
        trace_val = 0.0_dp
        do i = 1, n
            trace_val = trace_val + A(i,i)
        end do
    end function matrix_trace

    function matrix_frobenius_norm(A) result(norm_val)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp) :: norm_val
        norm_val = sqrt(sum(A * A))
    end function matrix_frobenius_norm

    subroutine matrix_copy(A, B)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:,:), intent(out) :: B
        call require(size(A,1) == size(B,1) .and. size(A,2) == size(B,2), 'matrix_copy: size mismatch')
        B = A
    end subroutine matrix_copy

    subroutine matrix_scale(A, alpha, B)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), intent(in) :: alpha
        real(dp), dimension(:,:), intent(out) :: B
        call require(size(A,1) == size(B,1) .and. size(A,2) == size(B,2), 'matrix_scale: size mismatch')
        B = alpha * A
    end subroutine matrix_scale

    subroutine matrix_row_swap(A, row1, row2)
        real(dp), dimension(:,:), intent(inout) :: A
        integer, intent(in) :: row1, row2
        real(dp), allocatable :: temp(:)
        call require(row1 >= 1 .and. row1 <= size(A,1), 'matrix_row_swap: row1 out of range')
        call require(row2 >= 1 .and. row2 <= size(A,1), 'matrix_row_swap: row2 out of range')
        allocate(temp(size(A,2)))
        temp = A(row1, :)
        A(row1, :) = A(row2, :)
        A(row2, :) = temp
        deallocate(temp)
    end subroutine matrix_row_swap

    subroutine matrix_col_swap(A, col1, col2)
        real(dp), dimension(:,:), intent(inout) :: A
        integer, intent(in) :: col1, col2
        real(dp), allocatable :: temp(:)
        call require(col1 >= 1 .and. col1 <= size(A,2), 'matrix_col_swap: col1 out of range')
        call require(col2 >= 1 .and. col2 <= size(A,2), 'matrix_col_swap: col2 out of range')
        allocate(temp(size(A,1)))
        temp = A(:, col1)
        A(:, col1) = A(:, col2)
        A(:, col2) = temp
        deallocate(temp)
    end subroutine matrix_col_swap

    function determinant(A) result(det)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp) :: det
        real(dp), allocatable :: U(:,:), L(:,:)
        integer, allocatable :: piv(:)
        integer :: info, n, i
        n = size(A,1)
        call require(n == size(A,2), 'determinant: not square')
        allocate(U(n,n), L(n,n), piv(n))
        call lu_factor(A, L, U, piv, info)
        if (info /= 0) then
            det = 0.0_dp
        else
            det = 1.0_dp
            do i = 1, n
                det = det * U(i,i)
            end do
            if (count(piv /= [(i, i=1,n)]) /= 0) then
                det = det * (-1.0_dp)**count(piv /= [(i, i=1,n)])
            end if
        end if
        deallocate(U, L, piv)
    end function determinant

    subroutine inverse_matrix(A, Ainv, info)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:,:), intent(out) :: Ainv
        integer, intent(out) :: info
        integer :: n, i
        real(dp), allocatable :: L(:,:), U(:,:), work(:,:), col(:), y(:)
        integer, allocatable :: piv(:)
        n = size(A,1)
        call require(n == size(A,2), 'inverse_matrix: not square')
        call require(size(Ainv,1) == n .and. size(Ainv,2) == n, 'inverse_matrix: output size mismatch')
        allocate(L(n,n), U(n,n), piv(n), work(n,n), col(n), y(n))
        call lu_factor(A, L, U, piv, info)
        if (info /= 0) then
            Ainv = 0.0_dp
            deallocate(L, U, piv, work, col, y)
            return
        end if
        do i = 1, n
            col = 0.0_dp
            col(i) = 1.0_dp
            call forward_substitution(L, col, y)
            call backward_substitution(U, y, work(:, i))
        end do
        call apply_pivot_inverse(work, piv, Ainv)
        deallocate(L, U, piv, work, col, y)
    end subroutine inverse_matrix

    subroutine apply_pivot_inverse(B, piv, X)
        real(dp), dimension(:,:), intent(in) :: B
        integer, dimension(:), intent(in) :: piv
        real(dp), dimension(:,:), intent(out) :: X
        integer :: n, i
        n = size(B,1)
        call require(size(B,2) == n, 'apply_pivot_inverse: not square')
        X = 0.0_dp
        do i = 1, n
            X(:, piv(i)) = B(:, i)
        end do
    end subroutine apply_pivot_inverse

    subroutine lu_factor(A, L, U, piv, info)
        real(dp), dimension(:,:), intent(in) :: A
        real(dp), dimension(:,:), intent(out) :: L, U
        integer, dimension(:), intent(out) :: piv
        integer, intent(out) :: info
        integer :: n, i, j, k, pivot_row
        real(dp) :: max_val
        real(dp), allocatable :: temp(:)

        n = size(A,1)
        call require(n == size(A,2), 'lu_factor: not square')
        call require(size(L,1) == n .and. size(L,2) == n, 'lu_factor: L size mismatch')
        call require(size(U,1) == n .and. size(U,2) == n, 'lu_factor: U size mismatch')
        call require(size(piv) == n, 'lu_factor: piv size mismatch')

        L = 0.0_dp
        U = A
        piv = [(i, i=1,n)]
        info = 0

        allocate(temp(n))
        do k = 1, n
            pivot_row = k
            max_val = abs(U(k,k))
            do i = k+1, n
                if (abs(U(i,k)) > max_val) then
                    max_val = abs(U(i,k))
                    pivot_row = i
                end if
            end do
            if (max_val == 0.0_dp) then
                info = k
                exit
            end if
            if (pivot_row /= k) then
                temp = U(k,:)
                U(k,:) = U(pivot_row,:)
                U(pivot_row,:) = temp
                temp = L(k,:)
                L(k,:) = L(pivot_row,:)
                L(pivot_row,:) = temp
                piv([k, pivot_row]) = piv([pivot_row, k])
            end if

            L(k,k) = 1.0_dp
            do i = k+1, n
                L(i,k) = U(i,k) / U(k,k)
                do j = k, n
                    U(i,j) = U(i,j) - L(i,k) * U(k,j)
                end do
            end do
        end do
        deallocate(temp)
    end subroutine lu_factor

    subroutine forward_substitution(L, b, y)
        real(dp), dimension(:,:), intent(in) :: L
        real(dp), dimension(:), intent(in) :: b
        real(dp), dimension(:), intent(out) :: y
        integer :: n, i, j
        n = size(L,1)
        call require(size(L,2) == n, 'forward_substitution: L not square')
        call require(size(b) == n .and. size(y) == n, 'forward_substitution: size mismatch')
        do i = 1, n
            y(i) = b(i)
            do j = 1, i-1
                y(i) = y(i) - L(i,j) * y(j)
            end do
            if (L(i,i) == 0.0_dp) call require(.false., 'forward_substitution: zero diagonal')
            y(i) = y(i) / L(i,i)
        end do
    end subroutine forward_substitution

    subroutine backward_substitution(U, y, x)
        real(dp), dimension(:,:), intent(in) :: U
        real(dp), dimension(:), intent(in) :: y
        real(dp), dimension(:), intent(out) :: x
        integer :: n, i, j
        n = size(U,1)
        call require(size(U,2) == n, 'backward_substitution: U not square')
        call require(size(y) == n .and. size(x) == n, 'backward_substitution: size mismatch')
        do i = n, 1, -1
            x(i) = y(i)
            do j = i+1, n
                x(i) = x(i) - U(i,j) * x(j)
            end do
            if (U(i,i) == 0.0_dp) call require(.false., 'backward_substitution: zero diagonal')
            x(i) = x(i) / U(i,i)
        end do
    end subroutine backward_substitution
end module matrix_operations
