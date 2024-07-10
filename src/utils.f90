module utils
    implicit none
    contains

    subroutine print_matrix(matrix)
        real(8), dimension(:,:), intent(in) :: matrix
        integer :: i, j

        do i = 1, size(matrix, 1)
            write(*, '(3(f6.2,1x))') (matrix(i, j), j = 1, size(matrix, 2))
        end do
    end subroutine print_matrix

end module utils
