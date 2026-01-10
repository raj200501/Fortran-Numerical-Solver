module differential_solver
    use kinds, only: dp
    use errors, only: require
    implicit none

    abstract interface
        subroutine ode_rhs(t, y, dydt)
            import dp
            real(dp), intent(in) :: t
            real(dp), dimension(:), intent(in) :: y
            real(dp), dimension(:), intent(out) :: dydt
        end subroutine ode_rhs
    end interface
contains
    subroutine euler_step(f, t, y, dt, y_next)
        procedure(ode_rhs) :: f
        real(dp), intent(in) :: t, dt
        real(dp), dimension(:), intent(in) :: y
        real(dp), dimension(:), intent(out) :: y_next
        real(dp), allocatable :: dydt(:)
        allocate(dydt(size(y)))
        call f(t, y, dydt)
        y_next = y + dt * dydt
        deallocate(dydt)
    end subroutine euler_step

    subroutine rk4_step(f, t, y, dt, y_next)
        procedure(ode_rhs) :: f
        real(dp), intent(in) :: t, dt
        real(dp), dimension(:), intent(in) :: y
        real(dp), dimension(:), intent(out) :: y_next
        integer :: n
        real(dp), allocatable :: k1(:), k2(:), k3(:), k4(:), y_temp(:)
        n = size(y)
        allocate(k1(n), k2(n), k3(n), k4(n), y_temp(n))
        call f(t, y, k1)
        y_temp = y + 0.5_dp * dt * k1
        call f(t + 0.5_dp*dt, y_temp, k2)
        y_temp = y + 0.5_dp * dt * k2
        call f(t + 0.5_dp*dt, y_temp, k3)
        y_temp = y + dt * k3
        call f(t + dt, y_temp, k4)
        y_next = y + (dt/6.0_dp) * (k1 + 2.0_dp*k2 + 2.0_dp*k3 + k4)
        deallocate(k1, k2, k3, k4, y_temp)
    end subroutine rk4_step

    subroutine solve_ivp(f, t0, t1, y0, dt, method, t_out, y_out)
        procedure(ode_rhs) :: f
        real(dp), intent(in) :: t0, t1, dt
        real(dp), dimension(:), intent(in) :: y0
        character(len=*), intent(in) :: method
        real(dp), dimension(:), intent(out) :: t_out
        real(dp), dimension(:,:), intent(out) :: y_out
        integer :: n_steps, n_state, i
        real(dp) :: t
        real(dp), allocatable :: y(:), y_next(:)

        call require(t1 > t0, 'solve_ivp: t1 must be > t0')
        call require(dt > 0.0_dp, 'solve_ivp: dt must be > 0')
        n_steps = int((t1 - t0) / dt) + 1
        n_state = size(y0)
        call require(size(t_out) == n_steps, 'solve_ivp: t_out size mismatch')
        call require(size(y_out,1) == n_state .and. size(y_out,2) == n_steps, 'solve_ivp: y_out shape mismatch')

        allocate(y(n_state), y_next(n_state))
        y = y0
        t = t0
        t_out(1) = t
        y_out(:,1) = y
        do i = 2, n_steps
            select case (trim(adjustl(method)))
            case ('euler')
                call euler_step(f, t, y, dt, y_next)
            case ('rk4')
                call rk4_step(f, t, y, dt, y_next)
            case default
                call require(.false., 'solve_ivp: unknown method')
            end select
            t = t + dt
            y = y_next
            t_out(i) = t
            y_out(:,i) = y
        end do
        deallocate(y, y_next)
    end subroutine solve_ivp
end module differential_solver
