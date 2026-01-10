module root_finding
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
    subroutine bisection(f, a, b, tol, max_iter, root, iterations, converged)
        procedure(scalar_fun) :: f
        real(dp), intent(in) :: a, b, tol
        integer, intent(in) :: max_iter
        real(dp), intent(out) :: root
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp) :: fa, fb, mid, fmid
        real(dp) :: left, right

        call require(tol > 0.0_dp, 'bisection: tol must be > 0')
        left = a
        right = b
        fa = f(left)
        fb = f(right)
        call require(fa * fb <= 0.0_dp, 'bisection: f(a) and f(b) must bracket root')
        converged = .false.

        do iterations = 1, max_iter
            mid = 0.5_dp * (left + right)
            fmid = f(mid)
            if (abs(fmid) <= tol .or. abs(right - left) <= tol) then
                converged = .true.
                root = mid
                return
            end if
            if (fa * fmid < 0.0_dp) then
                right = mid
                fb = fmid
            else
                left = mid
                fa = fmid
            end if
        end do
        root = mid
    end subroutine bisection

    subroutine newton(f, df, x0, tol, max_iter, root, iterations, converged)
        procedure(scalar_fun) :: f
        procedure(scalar_fun) :: df
        real(dp), intent(in) :: x0, tol
        integer, intent(in) :: max_iter
        real(dp), intent(out) :: root
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp) :: x, fx, dfx, step

        call require(tol > 0.0_dp, 'newton: tol must be > 0')
        x = x0
        converged = .false.
        do iterations = 1, max_iter
            fx = f(x)
            dfx = df(x)
            call require(dfx /= 0.0_dp, 'newton: derivative zero')
            step = fx / dfx
            x = x - step
            if (abs(step) < tol .or. abs(fx) < tol) then
                converged = .true.
                exit
            end if
        end do
        root = x
    end subroutine newton

    subroutine secant(f, x0, x1, tol, max_iter, root, iterations, converged)
        procedure(scalar_fun) :: f
        real(dp), intent(in) :: x0, x1, tol
        integer, intent(in) :: max_iter
        real(dp), intent(out) :: root
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp) :: x_prev, x_curr, x_next
        real(dp) :: f_prev, f_curr, denom

        call require(tol > 0.0_dp, 'secant: tol must be > 0')
        x_prev = x0
        x_curr = x1
        converged = .false.
        do iterations = 1, max_iter
            f_prev = f(x_prev)
            f_curr = f(x_curr)
            denom = f_curr - f_prev
            call require(denom /= 0.0_dp, 'secant: zero denominator')
            x_next = x_curr - f_curr * (x_curr - x_prev) / denom
            if (abs(x_next - x_curr) < tol .or. abs(f_curr) < tol) then
                converged = .true.
                x_curr = x_next
                exit
            end if
            x_prev = x_curr
            x_curr = x_next
        end do
        root = x_curr
    end subroutine secant
end module root_finding
