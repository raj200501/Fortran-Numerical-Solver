module test_optimization_time_series
    use kinds, only: dp
    use optimization, only: gradient_descent, momentum_descent, backtracking_line_search
    use time_series, only: moving_average, exponential_smoothing, mean_absolute_error, mean_squared_error, root_mean_squared_error
    use test_support, only: assert_near, assert_true, assert_vector_near
    implicit none
contains
    subroutine run_optimization_time_series_tests()
        real(dp) :: x_opt, alpha
        integer :: iterations
        logical :: converged
        real(dp), dimension(5) :: x, y
        real(dp), dimension(5) :: expected_ma

        call gradient_descent(f, g, 5.0_dp, 0.1_dp, 1.0e-8_dp, 200, x_opt, iterations, converged)
        call assert_true(converged, 'gradient_descent converged')
        call assert_near(x_opt, 2.0_dp, 1.0e-5_dp, 'gradient_descent optimum')

        call momentum_descent(f, g, -4.0_dp, 0.1_dp, 0.9_dp, 1.0e-6_dp, 300, x_opt, iterations, converged)
        call assert_true(converged, 'momentum_descent converged')
        call assert_near(x_opt, 2.0_dp, 1.0e-3_dp, 'momentum_descent optimum')

        call backtracking_line_search(f, g, 0.0_dp, -g(0.0_dp), 1.0_dp, 0.5_dp, 1.0e-4_dp, alpha)
        call assert_true(alpha > 0.0_dp, 'backtracking_line_search alpha')

        x = (/1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp/)
        call moving_average(x, 3, y)
        expected_ma = (/1.0_dp, 1.5_dp, 2.0_dp, 3.0_dp, 4.0_dp/)
        call assert_vector_near(y, expected_ma, 1.0e-12_dp, 'moving_average')

        call exponential_smoothing(x, 0.5_dp, y)
        call assert_near(y(2), 1.5_dp, 1.0e-12_dp, 'exponential_smoothing y2')

        call assert_near(mean_absolute_error(x, x+1.0_dp), 1.0_dp, 1.0e-12_dp, 'mean_absolute_error')
        call assert_near(mean_squared_error(x, x+1.0_dp), 1.0_dp, 1.0e-12_dp, 'mean_squared_error')
        call assert_near(root_mean_squared_error(x, x+1.0_dp), 1.0_dp, 1.0e-12_dp, 'root_mean_squared_error')
    end subroutine run_optimization_time_series_tests

    function f(x) result(fx)
        real(dp), intent(in) :: x
        real(dp) :: fx
        fx = (x - 2.0_dp)**2
    end function f

    function g(x) result(gx)
        real(dp), intent(in) :: x
        real(dp) :: gx
        gx = 2.0_dp * (x - 2.0_dp)
    end function g
end module test_optimization_time_series
