module test_linear_solver
    use kinds, only: dp
    use linear_solver, only: solve_linear_system, jacobi_solver, gauss_seidel_solver, conjugate_gradient_solver
    use test_support, only: assert_vector_near, assert_true
    implicit none
contains
    subroutine run_linear_solver_tests()
        real(dp), dimension(3,3) :: A
        real(dp), dimension(3) :: b, x, expected
        integer :: info, iterations
        logical :: converged

        A = reshape((/3.0_dp, -0.1_dp, -0.2_dp, 0.1_dp, 7.0_dp, -0.3_dp, 0.3_dp, -0.2_dp, 10.0_dp/), (/3,3/))
        b = (/7.85_dp, -19.3_dp, 71.4_dp/)
        expected = (/3.0_dp, -2.5_dp, 7.0_dp/)

        call solve_linear_system(A, b, x, info)
        call assert_true(info == 0, 'LU solver info should be 0')
        call assert_vector_near(x, expected, 1.0e-6_dp, 'LU solver solution')

        x = 0.0_dp
        call jacobi_solver(A, b, x, 200, 1.0e-8_dp, iterations, converged)
        call assert_true(converged, 'Jacobi solver should converge')
        call assert_vector_near(x, expected, 1.0e-5_dp, 'Jacobi solver solution')

        x = 0.0_dp
        call gauss_seidel_solver(A, b, x, 200, 1.0e-10_dp, iterations, converged)
        call assert_true(converged, 'Gauss-Seidel solver should converge')
        call assert_vector_near(x, expected, 1.0e-6_dp, 'Gauss-Seidel solver solution')

        x = 0.0_dp
        call conjugate_gradient_solver(A, b, x, 200, 1.0e-10_dp, iterations, converged)
        call assert_true(converged, 'Conjugate Gradient solver should converge')
        call assert_vector_near(x, expected, 1.0e-6_dp, 'Conjugate Gradient solver solution')
    end subroutine run_linear_solver_tests
end module test_linear_solver
