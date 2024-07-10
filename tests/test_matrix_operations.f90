program test_matrix_operations
    use matrix_operations
    implicit none

    real(8), dimension(3,3) :: A, B, C

    A = reshape((/1.0d0, 2.0d0, 3.0d0, 4.0d0, 5.0d0, 6.0d0, 7.0d0, 8.0d0, 9.0d0/), (/3,3/))
    B = reshape((/9.0d0, 8.0d0, 7.0d0, 6.0d0, 5.0d0, 4.0d0, 3.0d0, 2.0d0, 1.0d0/), (/3,3/))
    call matrix_multiply(A, B, C)
    print *, "Test Result of matrix multiplication: ", C

end program test_matrix_operations
