program test_utils
    use utils
    implicit none

    real(8), dimension(3,3) :: matrix

    matrix = reshape((/1.0d0, 2.0d0, 3.0d0, 4.0d0, 5.0d0, 6.0d0, 7.0d0, 8.0d0, 9.0d0/), (/3,3/))
    call print_matrix(matrix)

end program test_utils
