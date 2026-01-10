module test_config
    use kinds, only: dp
    use config, only: solver_config, load_config
    use test_support, only: assert_near, assert_true
    implicit none
contains
    subroutine run_config_tests()
        type(solver_config) :: cfg
        call load_config('tests/fixtures/sample_config.cfg', cfg)
        call assert_true(cfg%linear_size == 3, 'config linear_size')
        call assert_near(cfg%ode_t0, 0.0_dp, 1.0e-12_dp, 'config ode_t0')
        call assert_near(cfg%ode_t1, 4.0_dp, 1.0e-12_dp, 'config ode_t1')
        call assert_true(trim(cfg%ode_method) == 'euler', 'config ode_method')
    end subroutine run_config_tests
end module test_config
