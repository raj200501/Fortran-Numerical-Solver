module matrix_operations
    implicit none
    contains

    subroutine matrix_multiply(A, B, C)
        real(8), dimension(:,:), intent(in) :: A, B
        real(8), dimension(:,:), intent(out) :: C
        integer :: n, m, k

        n = size(A, 1)
        m = size(B, 2)
        k = size(A, 2)

        C = 0.0d0
        C = matmul(A, B)
    end subroutine matrix_multiply

end module matrix_operations
