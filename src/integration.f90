module integration
    use kinds, only: dp
    use errors, only: require
    implicit none

    abstract interface
        function scalar_fun(x) result(fx)
            import dp
            real(dp), intent(in) :: x
            real(dp) :: fx
        end function scalar_fun
    end interface
contains
    function trapezoidal(f, a, b, n) result(area)
        procedure(scalar_fun) :: f
        real(dp), intent(in) :: a, b
        integer, intent(in) :: n
        real(dp) :: area
        real(dp) :: h
        integer :: i
        call require(n >= 1, 'trapezoidal: n must be >= 1')
        h = (b - a) / real(n, dp)
        area = 0.5_dp * (f(a) + f(b))
        do i = 1, n-1
            area = area + f(a + h * real(i, dp))
        end do
        area = area * h
    end function trapezoidal

    function simpson(f, a, b, n) result(area)
        procedure(scalar_fun) :: f
        real(dp), intent(in) :: a, b
        integer, intent(in) :: n
        real(dp) :: area
        real(dp) :: h
        integer :: i
        call require(mod(n,2) == 0, 'simpson: n must be even')
        h = (b - a) / real(n, dp)
        area = f(a) + f(b)
        do i = 1, n-1
            if (mod(i,2) == 0) then
                area = area + 2.0_dp * f(a + h * real(i, dp))
            else
                area = area + 4.0_dp * f(a + h * real(i, dp))
            end if
        end do
        area = area * h / 3.0_dp
    end function simpson

    function adaptive_trapezoidal(f, a, b, tol, max_iter, iterations, converged) result(area)
        procedure(scalar_fun) :: f
        real(dp), intent(in) :: a, b, tol
        integer, intent(in) :: max_iter
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp) :: area
        real(dp) :: prev_area, curr_area
        integer :: n

        call require(tol > 0.0_dp, 'adaptive_trapezoidal: tol must be > 0')
        n = 1
        prev_area = trapezoidal(f, a, b, n)
        converged = .false.
        do iterations = 1, max_iter
            n = n * 2
            curr_area = trapezoidal(f, a, b, n)
            if (abs(curr_area - prev_area) < tol) then
                converged = .true.
                area = curr_area
                return
            end if
            prev_area = curr_area
        end do
        area = curr_area
    end function adaptive_trapezoidal
end module integration
