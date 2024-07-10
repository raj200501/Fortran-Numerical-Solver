module linear_solver
    implicit none
    contains

    subroutine solve_linear_system(A, b, x)
        real(8), dimension(:,:), intent(in) :: A
        real(8), dimension(:), intent(in) :: b
        real(8), dimension(:), intent(out) :: x
        real(8), dimension(size(b)) :: temp_b
        integer :: n, i, info

        n = size(b)
        temp_b = b
        call dgesv(n, 1, A, n, temp_b, x, n, info)
        if (info /= 0) print *, "Error solving the linear system: ", info
    end subroutine solve_linear_system

end module linear_solver
