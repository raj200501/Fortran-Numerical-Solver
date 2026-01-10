module interpolation
    use kinds, only: dp
    use errors, only: require
    implicit none
contains
    function linear_interpolate(x0, y0, x1, y1, x) result(y)
        real(dp), intent(in) :: x0, y0, x1, y1, x
        real(dp) :: y
        call require(x1 /= x0, 'linear_interpolate: x0 and x1 must be different')
        y = y0 + (y1 - y0) * (x - x0) / (x1 - x0)
    end function linear_interpolate

    function lagrange_interpolate(x_data, y_data, x) result(y)
        real(dp), dimension(:), intent(in) :: x_data, y_data
        real(dp), intent(in) :: x
        real(dp) :: y
        integer :: n, i, j
        real(dp) :: term
        n = size(x_data)
        call require(n == size(y_data), 'lagrange_interpolate: size mismatch')
        call require(n > 1, 'lagrange_interpolate: need at least two points')
        y = 0.0_dp
        do i = 1, n
            term = y_data(i)
            do j = 1, n
                if (j /= i) then
                    call require(x_data(i) /= x_data(j), 'lagrange_interpolate: duplicate x values')
                    term = term * (x - x_data(j)) / (x_data(i) - x_data(j))
                end if
            end do
            y = y + term
        end do
    end function lagrange_interpolate

    subroutine linspace(a, b, n, x)
        real(dp), intent(in) :: a, b
        integer, intent(in) :: n
        real(dp), dimension(:), intent(out) :: x
        integer :: i
        call require(n >= 2, 'linspace: n must be >= 2')
        call require(size(x) == n, 'linspace: output size mismatch')
        do i = 1, n
            x(i) = a + (b - a) * real(i - 1, dp) / real(n - 1, dp)
        end do
    end subroutine linspace
end module interpolation
