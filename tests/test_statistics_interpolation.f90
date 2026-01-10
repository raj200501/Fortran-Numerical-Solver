module test_statistics_interpolation
    use kinds, only: dp
    use statistics, only: mean_vector, variance_vector, stddev_vector, covariance_matrix
    use interpolation, only: linear_interpolate, lagrange_interpolate, linspace
    use test_support, only: assert_near, assert_true, assert_vector_near
    implicit none
contains
    subroutine run_statistics_interpolation_tests()
        real(dp), dimension(4) :: x
        real(dp), dimension(3) :: lin
        real(dp), dimension(3,2) :: data
        real(dp), dimension(2,2) :: cov
        real(dp) :: y

        x = (/1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp/)
        call assert_near(mean_vector(x), 2.5_dp, 1.0e-12_dp, 'mean_vector')
        call assert_near(variance_vector(x), 1.25_dp, 1.0e-12_dp, 'variance_vector')
        call assert_near(stddev_vector(x), sqrt(1.25_dp), 1.0e-12_dp, 'stddev_vector')

        data(:,1) = (/1.0_dp, 2.0_dp, 3.0_dp/)
        data(:,2) = (/2.0_dp, 4.0_dp, 6.0_dp/)
        call covariance_matrix(data, cov)
        call assert_near(cov(1,1), 1.0_dp, 1.0e-12_dp, 'covariance_matrix(1,1)')
        call assert_near(cov(1,2), 2.0_dp, 1.0e-12_dp, 'covariance_matrix(1,2)')

        y = linear_interpolate(0.0_dp, 0.0_dp, 10.0_dp, 20.0_dp, 2.5_dp)
        call assert_near(y, 5.0_dp, 1.0e-12_dp, 'linear_interpolate')

        y = lagrange_interpolate((/0.0_dp, 1.0_dp, 2.0_dp/), (/1.0_dp, 3.0_dp, 5.0_dp/), 1.5_dp)
        call assert_near(y, 4.0_dp, 1.0e-12_dp, 'lagrange_interpolate')

        call linspace(0.0_dp, 1.0_dp, 3, lin)
        call assert_vector_near(lin, (/0.0_dp, 0.5_dp, 1.0_dp/), 1.0e-12_dp, 'linspace')
    end subroutine run_statistics_interpolation_tests
end module test_statistics_interpolation
