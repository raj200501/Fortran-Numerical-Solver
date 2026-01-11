module optimization
    use kinds, only: dp
    use errors, only: require
    implicit none

    abstract interface
        function scalar_fun(x) result(fx)
            import dp
            real(dp), intent(in) :: x
            real(dp) :: fx
        end function scalar_fun
        function scalar_grad(x) result(gx)
            import dp
            real(dp), intent(in) :: x
            real(dp) :: gx
        end function scalar_grad
    end interface
contains
    subroutine gradient_descent(f, g, x0, alpha, tol, max_iter, x_opt, iterations, converged)
        procedure(scalar_fun) :: f
        procedure(scalar_grad) :: g
        real(dp), intent(in) :: x0, alpha, tol
        integer, intent(in) :: max_iter
        real(dp), intent(out) :: x_opt
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp) :: x, grad, step

        call require(alpha > 0.0_dp, 'gradient_descent: alpha must be > 0')
        call require(tol > 0.0_dp, 'gradient_descent: tol must be > 0')

        x = x0
        converged = .false.
        do iterations = 1, max_iter
            grad = g(x)
            step = alpha * grad
            x = x - step
            if (abs(step) < tol .or. abs(grad) < tol) then
                converged = .true.
                exit
            end if
        end do
        x_opt = x
    end subroutine gradient_descent

    subroutine momentum_descent(f, g, x0, alpha, beta, tol, max_iter, x_opt, iterations, converged)
        procedure(scalar_fun) :: f
        procedure(scalar_grad) :: g
        real(dp), intent(in) :: x0, alpha, beta, tol
        integer, intent(in) :: max_iter
        real(dp), intent(out) :: x_opt
        integer, intent(out) :: iterations
        logical, intent(out) :: converged
        real(dp) :: x, v, grad

        call require(alpha > 0.0_dp, 'momentum_descent: alpha must be > 0')
        call require(beta >= 0.0_dp .and. beta < 1.0_dp, 'momentum_descent: beta must be in [0,1)')
        call require(tol > 0.0_dp, 'momentum_descent: tol must be > 0')

        x = x0
        v = 0.0_dp
        converged = .false.
        do iterations = 1, max_iter
            grad = g(x)
            v = beta * v + alpha * grad
            x = x - v
            if (abs(v) < tol .or. abs(grad) < tol) then
                converged = .true.
                exit
            end if
        end do
        x_opt = x
    end subroutine momentum_descent

    subroutine backtracking_line_search(f, g, x, direction, alpha0, rho, c, alpha)
        procedure(scalar_fun) :: f
        procedure(scalar_grad) :: g
        real(dp), intent(in) :: x, direction, alpha0, rho, c
        real(dp), intent(out) :: alpha
        real(dp) :: fx, gdir
        call require(alpha0 > 0.0_dp, 'backtracking_line_search: alpha0 must be > 0')
        call require(rho > 0.0_dp .and. rho < 1.0_dp, 'backtracking_line_search: rho must be in (0,1)')
        call require(c > 0.0_dp .and. c < 1.0_dp, 'backtracking_line_search: c must be in (0,1)')

        alpha = alpha0
        fx = f(x)
        gdir = g(x) * direction
        do
            if (f(x + alpha * direction) <= fx + c * alpha * gdir) exit
            alpha = alpha * rho
            if (alpha < 1.0e-12_dp) exit
        end do
    end subroutine backtracking_line_search
end module optimization
