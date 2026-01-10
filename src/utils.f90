module utils
    use kinds, only: dp
    implicit none
contains
    subroutine print_matrix(matrix, title)
        real(dp), dimension(:,:), intent(in) :: matrix
        character(len=*), intent(in), optional :: title
        integer :: i, j
        if (present(title)) then
            write(*,'(a)') trim(title)
        end if
        do i = 1, size(matrix, 1)
            write(*, '(100(f10.4,1x))') (matrix(i, j), j = 1, size(matrix, 2))
        end do
    end subroutine print_matrix

    subroutine print_vector(vector, title)
        real(dp), dimension(:), intent(in) :: vector
        character(len=*), intent(in), optional :: title
        integer :: i
        if (present(title)) then
            write(*,'(a)') trim(title)
        end if
        do i = 1, size(vector)
            write(*, '(a,i0,a,f10.4)') '  [', i, '] = ', vector(i)
        end do
    end subroutine print_vector

    function near(a, b, tol) result(is_close)
        real(dp), intent(in) :: a, b, tol
        logical :: is_close
        is_close = abs(a - b) <= tol
    end function near

    function max_abs_diff(a, b) result(diff)
        real(dp), dimension(:), intent(in) :: a, b
        real(dp) :: diff
        integer :: i
        diff = 0.0_dp
        do i = 1, size(a)
            diff = max(diff, abs(a(i) - b(i)))
        end do
    end function max_abs_diff

    function max_abs_diff_matrix(a, b) result(diff)
        real(dp), dimension(:,:), intent(in) :: a, b
        real(dp) :: diff
        integer :: i, j
        diff = 0.0_dp
        do i = 1, size(a,1)
            do j = 1, size(a,2)
                diff = max(diff, abs(a(i,j) - b(i,j)))
            end do
        end do
    end function max_abs_diff_matrix
end module utils
