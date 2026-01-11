program test_runner
    use test_support, only: report_and_exit
    use test_linear_solver, only: run_linear_solver_tests
    use test_matrix_operations, only: run_matrix_operations_tests
    use test_differential_solver, only: run_differential_solver_tests
    use test_config, only: run_config_tests
    use test_root_finding, only: run_root_finding_tests
    use test_integration, only: run_integration_tests
    use test_linear_algebra_extras, only: run_linear_algebra_extras_tests
    use test_statistics_interpolation, only: run_statistics_interpolation_tests
    use test_optimization_time_series, only: run_optimization_time_series_tests
    implicit none

    call run_linear_solver_tests()
    call run_matrix_operations_tests()
    call run_differential_solver_tests()
    call run_config_tests()
    call run_root_finding_tests()
    call run_integration_tests()
    call run_linear_algebra_extras_tests()
    call run_statistics_interpolation_tests()
    call run_optimization_time_series_tests()
    call report_and_exit()
end program test_runner
