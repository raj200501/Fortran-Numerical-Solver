module config
    use kinds, only: dp
    use errors, only: require
    implicit none

    type :: solver_config
        integer :: linear_size = 3
        real(dp) :: ode_t0 = 0.0_dp
        real(dp) :: ode_t1 = 2.0_dp
        real(dp) :: ode_dt = 0.1_dp
        real(dp) :: ode_r = 1.5_dp
        real(dp) :: ode_k = 10.0_dp
        character(len=16) :: ode_method = 'rk4'
    end type solver_config
contains
    subroutine load_config(path, cfg)
        character(len=*), intent(in) :: path
        type(solver_config), intent(inout) :: cfg
        character(len=256) :: line, key, value
        integer :: ios, pos
        open(unit=10, file=trim(path), status='old', action='read', iostat=ios)
        call require(ios == 0, 'load_config: failed to open config file: ' // trim(path))
        do
            read(10, '(A)', iostat=ios) line
            if (ios /= 0) exit
            if (len_trim(line) == 0) cycle
            if (line(1:1) == '#') cycle
            pos = index(line, '=')
            if (pos <= 1) cycle
            key = adjustl(line(1:pos-1))
            value = adjustl(line(pos+1:))
            call parse_entry(trim(key), trim(value), cfg)
        end do
        close(10)
    end subroutine load_config

    subroutine parse_entry(key, value, cfg)
        character(len=*), intent(in) :: key, value
        type(solver_config), intent(inout) :: cfg
        select case (trim(key))
        case ('linear_size')
            read(value, *) cfg%linear_size
        case ('ode_t0')
            read(value, *) cfg%ode_t0
        case ('ode_t1')
            read(value, *) cfg%ode_t1
        case ('ode_dt')
            read(value, *) cfg%ode_dt
        case ('ode_r')
            read(value, *) cfg%ode_r
        case ('ode_k')
            read(value, *) cfg%ode_k
        case ('ode_method')
            cfg%ode_method = trim(value)
        case default
            ! ignore unknown keys
        end select
    end subroutine parse_entry
end module config
