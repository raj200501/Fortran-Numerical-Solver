module test_matrix_operations
    use kinds, only: dp
    use matrix_operations, only: matrix_multiply, matrix_transpose, matrix_trace, matrix_frobenius_norm, inverse_matrix, determinant
    use test_support, only: assert_vector_near, assert_near, assert_true
    implicit none
contains
    subroutine run_matrix_operations_tests()
        real(dp), dimension(2,2) :: A, B, C, AT, Ainv
        real(dp), dimension(2) :: expected_row
        integer :: info
        real(dp) :: detA

        A = reshape((/4.0_dp, 7.0_dp, 2.0_dp, 6.0_dp/), (/2,2/))
        B = reshape((/1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp/), (/2,2/))
        call matrix_multiply(A, B, C)
        expected_row = (/25.0_dp, 36.0_dp/)
        call assert_vector_near(C(1,:), expected_row, 1.0e-10_dp, 'matrix_multiply first row')

        call matrix_transpose(A, AT)
        call assert_near(AT(2,1), 7.0_dp, 1.0e-12_dp, 'matrix_transpose element')

        call assert_near(matrix_trace(A), 10.0_dp, 1.0e-12_dp, 'matrix_trace')
        call assert_near(matrix_frobenius_norm(A), sqrt(sum(A*A)), 1.0e-12_dp, 'matrix_frobenius_norm')

        detA = determinant(A)
        call assert_near(detA, 10.0_dp, 1.0e-8_dp, 'determinant')
        call inverse_matrix(A, Ainv, info)
        call assert_true(info == 0, 'inverse_matrix info')
        call assert_near(Ainv(1,1), 0.6_dp, 1.0e-6_dp, 'inverse_matrix element')
        call assert_near(Ainv(2,2), 0.4_dp, 1.0e-6_dp, 'inverse_matrix element')
    end subroutine run_matrix_operations_tests
end module test_matrix_operations
