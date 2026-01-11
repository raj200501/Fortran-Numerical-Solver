module test_integration
    use kinds, only: dp
    use integration, only: trapezoidal, simpson, adaptive_trapezoidal
    use test_support, only: assert_near, assert_true
    implicit none
contains
    subroutine run_integration_tests()
        real(dp) :: area
        integer :: iterations
        logical :: converged

        area = trapezoidal(f, 0.0_dp, 1.0_dp, 1000)
        call assert_near(area, 1.0_dp/3.0_dp, 1.0e-4_dp, 'trapezoidal integral')

        area = simpson(f, 0.0_dp, 1.0_dp, 100)
        call assert_near(area, 1.0_dp/3.0_dp, 1.0e-6_dp, 'simpson integral')

        area = adaptive_trapezoidal(f, 0.0_dp, 1.0_dp, 1.0e-6_dp, 20, iterations, converged)
        call assert_true(converged, 'adaptive_trapezoidal converged')
        call assert_near(area, 1.0_dp/3.0_dp, 1.0e-4_dp, 'adaptive trapezoidal integral')
    end subroutine run_integration_tests

    function f(x) result(fx)
        real(dp), intent(in) :: x
        real(dp) :: fx
        fx = x * x
    end function f
end module test_integration
