program main
    use kinds, only: dp
    use utils, only: print_matrix, print_vector
    use linear_solver, only: solve_linear_system, jacobi_solver, gauss_seidel_solver, conjugate_gradient_solver
    use matrix_operations, only: matrix_multiply, matrix_transpose, matrix_trace, matrix_frobenius_norm
    use differential_solver, only: solve_ivp
    use config, only: solver_config, load_config
    use errors, only: require
    implicit none

    type(solver_config) :: cfg
    character(len=256) :: config_path
    logical :: has_config

    has_config = .false.
    if (command_argument_count() >= 1) then
        call get_command_argument(1, config_path)
        has_config = len_trim(config_path) > 0
    end if

    if (has_config) then
        call load_config(trim(config_path), cfg)
        write(*,'(a)') 'Loaded configuration from ' // trim(config_path)
    else
        write(*,'(a)') 'Using built-in default configuration'
    end if

    call run_linear_system_example(cfg)
    call run_differential_equation_example(cfg)
    call run_matrix_operations_example()

contains
    subroutine run_linear_system_example(cfg)
        type(solver_config), intent(in) :: cfg
        real(dp), allocatable :: A(:,:), b(:), x(:)
        integer :: n, info
        integer :: iterations
        logical :: converged

        n = cfg%linear_size
        call require(n == 3, 'current demo expects linear_size = 3')
        allocate(A(n,n), b(n), x(n))
        A = reshape((/3.0_dp, -0.1_dp, -0.2_dp, 0.1_dp, 7.0_dp, -0.3_dp, 0.3_dp, -0.2_dp, 10.0_dp/), (/3,3/))
        b = (/7.85_dp, -19.3_dp, 71.4_dp/)

        call solve_linear_system(A, b, x, info)
        if (info /= 0) then
            write(*,'(a,i0)') 'LU solver failed, info = ', info
        else
            call print_vector(x, 'Solution of the linear system (LU):')
        end if

        x = 0.0_dp
        call jacobi_solver(A, b, x, 100, 1.0e-8_dp, iterations, converged)
        write(*,'(a,l1,a,i0)') 'Jacobi converged: ', converged, ' in iterations: ', iterations
        call print_vector(x, 'Solution of the linear system (Jacobi):')

        x = 0.0_dp
        call gauss_seidel_solver(A, b, x, 100, 1.0e-10_dp, iterations, converged)
        write(*,'(a,l1,a,i0)') 'Gauss-Seidel converged: ', converged, ' in iterations: ', iterations
        call print_vector(x, 'Solution of the linear system (Gauss-Seidel):')

        x = 0.0_dp
        call conjugate_gradient_solver(A, b, x, 100, 1.0e-10_dp, iterations, converged)
        write(*,'(a,l1,a,i0)') 'Conjugate Gradient converged: ', converged, ' in iterations: ', iterations
        call print_vector(x, 'Solution of the linear system (Conjugate Gradient):')

        deallocate(A, b, x)
    end subroutine run_linear_system_example

    subroutine run_differential_equation_example(cfg)
        type(solver_config), intent(in) :: cfg
        real(dp), allocatable :: t(:), y(:,:)
        real(dp), dimension(1) :: y0
        integer :: n_steps

        n_steps = int((cfg%ode_t1 - cfg%ode_t0) / cfg%ode_dt) + 1
        allocate(t(n_steps), y(1, n_steps))
        y0 = 0.5_dp
        call solve_ivp(logistic_rhs, cfg%ode_t0, cfg%ode_t1, y0, cfg%ode_dt, cfg%ode_method, t, y)
        write(*,'(a)') 'Differential equation (logistic growth) sample:'
        write(*,'(a)') '  t       y'
        write(*,'(f6.2,2x,f10.5)') t(1), y(1,1)
        write(*,'(f6.2,2x,f10.5)') t(n_steps), y(1,n_steps)
        deallocate(t, y)
    end subroutine run_differential_equation_example

    subroutine logistic_rhs(t, y, dydt)
        real(dp), intent(in) :: t
        real(dp), dimension(:), intent(in) :: y
        real(dp), dimension(:), intent(out) :: dydt
        real(dp) :: r, k
        r = cfg%ode_r
        k = cfg%ode_k
        dydt(1) = r * y(1) * (1.0_dp - y(1) / k)
    end subroutine logistic_rhs

    subroutine run_matrix_operations_example()
        real(dp), dimension(3,3) :: A, B, C, AT
        real(dp) :: tr, fnorm
        A = reshape((/1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp, 6.0_dp, 7.0_dp, 8.0_dp, 9.0_dp/), (/3,3/))
        B = reshape((/9.0_dp, 8.0_dp, 7.0_dp, 6.0_dp, 5.0_dp, 4.0_dp, 3.0_dp, 2.0_dp, 1.0_dp/), (/3,3/))
        call matrix_multiply(A, B, C)
        call print_matrix(C, 'Result of matrix multiplication:')
        call matrix_transpose(A, AT)
        call print_matrix(AT, 'Transpose of A:')
        tr = matrix_trace(A)
        fnorm = matrix_frobenius_norm(A)
        write(*,'(a,f10.4)') 'Trace of A: ', tr
        write(*,'(a,f10.4)') 'Frobenius norm of A: ', fnorm
    end subroutine run_matrix_operations_example
end program main
