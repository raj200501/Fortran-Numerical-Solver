module time_series
    use kinds, only: dp
    use errors, only: require
    implicit none
contains
    subroutine moving_average(x, window, y)
        real(dp), dimension(:), intent(in) :: x
        integer, intent(in) :: window
        real(dp), dimension(:), intent(out) :: y
        integer :: n, i, j
        real(dp) :: sum

        n = size(x)
        call require(window >= 1 .and. window <= n, 'moving_average: invalid window')
        call require(size(y) == n, 'moving_average: output size mismatch')

        do i = 1, n
            sum = 0.0_dp
            do j = max(1, i - window + 1), i
                sum = sum + x(j)
            end do
            y(i) = sum / real(min(i, window), dp)
        end do
    end subroutine moving_average

    subroutine exponential_smoothing(x, alpha, y)
        real(dp), dimension(:), intent(in) :: x
        real(dp), intent(in) :: alpha
        real(dp), dimension(:), intent(out) :: y
        integer :: n, i

        n = size(x)
        call require(alpha > 0.0_dp .and. alpha <= 1.0_dp, 'exponential_smoothing: alpha must be in (0,1]')
        call require(size(y) == n, 'exponential_smoothing: output size mismatch')

        y(1) = x(1)
        do i = 2, n
            y(i) = alpha * x(i) + (1.0_dp - alpha) * y(i-1)
        end do
    end subroutine exponential_smoothing

    function mean_absolute_error(actual, predicted) result(mae)
        real(dp), dimension(:), intent(in) :: actual, predicted
        real(dp) :: mae
        call require(size(actual) == size(predicted), 'mean_absolute_error: size mismatch')
        mae = sum(abs(actual - predicted)) / real(size(actual), dp)
    end function mean_absolute_error

    function mean_squared_error(actual, predicted) result(mse)
        real(dp), dimension(:), intent(in) :: actual, predicted
        real(dp) :: mse
        call require(size(actual) == size(predicted), 'mean_squared_error: size mismatch')
        mse = sum((actual - predicted)**2) / real(size(actual), dp)
    end function mean_squared_error

    function root_mean_squared_error(actual, predicted) result(rmse)
        real(dp), dimension(:), intent(in) :: actual, predicted
        real(dp) :: rmse
        rmse = sqrt(mean_squared_error(actual, predicted))
    end function root_mean_squared_error
end module time_series
