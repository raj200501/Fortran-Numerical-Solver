module test_root_finding
    use kinds, only: dp
    use root_finding, only: bisection, newton, secant
    use test_support, only: assert_near, assert_true
    implicit none
contains
    subroutine run_root_finding_tests()
        real(dp) :: root
        integer :: iterations
        logical :: converged

        call bisection(f, 0.0_dp, 2.0_dp, 1.0e-8_dp, 100, root, iterations, converged)
        call assert_true(converged, 'bisection converged')
        call assert_near(root, 1.41421356_dp, 1.0e-6_dp, 'bisection root')

        call newton(f, df, 1.0_dp, 1.0e-10_dp, 50, root, iterations, converged)
        call assert_true(converged, 'newton converged')
        call assert_near(root, 1.41421356_dp, 1.0e-8_dp, 'newton root')

        call secant(f, 1.0_dp, 2.0_dp, 1.0e-10_dp, 50, root, iterations, converged)
        call assert_true(converged, 'secant converged')
        call assert_near(root, 1.41421356_dp, 1.0e-6_dp, 'secant root')
    end subroutine run_root_finding_tests

    function f(x) result(fx)
        real(dp), intent(in) :: x
        real(dp) :: fx
        fx = x * x - 2.0_dp
    end function f

    function df(x) result(fx)
        real(dp), intent(in) :: x
        real(dp) :: fx
        fx = 2.0_dp * x
    end function df
end module test_root_finding
