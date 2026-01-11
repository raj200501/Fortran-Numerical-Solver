module test_differential_solver
    use kinds, only: dp
    use differential_solver, only: solve_ivp
    use test_support, only: assert_near, assert_true
    implicit none
contains
    subroutine run_differential_solver_tests()
        real(dp), allocatable :: t(:), y(:,:)
        real(dp), dimension(1) :: y0
        integer :: n_steps

        n_steps = 11
        allocate(t(n_steps), y(1, n_steps))
        y0 = 1.0_dp
        call solve_ivp(exp_rhs, 0.0_dp, 1.0_dp, y0, 0.1_dp, 'rk4', t, y)
        call assert_near(y(1,1), 1.0_dp, 1.0e-12_dp, 'ode initial condition')
        call assert_true(abs(y(1,n_steps) - exp(1.0_dp)) < 1.0e-3_dp, 'ode final value close to exp(1)')
        deallocate(t, y)
    end subroutine run_differential_solver_tests

    subroutine exp_rhs(t, y, dydt)
        real(dp), intent(in) :: t
        real(dp), dimension(:), intent(in) :: y
        real(dp), dimension(:), intent(out) :: dydt
        dydt(1) = y(1)
    end subroutine exp_rhs
end module test_differential_solver
