module statistics
    use kinds, only: dp
    use errors, only: require
    implicit none
contains
    function mean_vector(x) result(mu)
        real(dp), dimension(:), intent(in) :: x
        real(dp) :: mu
        call require(size(x) > 0, 'mean_vector: empty vector')
        mu = sum(x) / real(size(x), dp)
    end function mean_vector

    function variance_vector(x, sample) result(var)
        real(dp), dimension(:), intent(in) :: x
        logical, intent(in), optional :: sample
        real(dp) :: var
        real(dp) :: mu
        integer :: n
        logical :: use_sample
        n = size(x)
        call require(n > 1, 'variance_vector: need at least two samples')
        use_sample = .false.
        if (present(sample)) use_sample = sample
        mu = mean_vector(x)
        var = sum((x - mu)**2)
        if (use_sample) then
            var = var / real(n - 1, dp)
        else
            var = var / real(n, dp)
        end if
    end function variance_vector

    function stddev_vector(x, sample) result(sd)
        real(dp), dimension(:), intent(in) :: x
        logical, intent(in), optional :: sample
        real(dp) :: sd
        sd = sqrt(variance_vector(x, sample))
    end function stddev_vector

    subroutine covariance_matrix(data, cov)
        real(dp), dimension(:,:), intent(in) :: data
        real(dp), dimension(:,:), intent(out) :: cov
        integer :: n_samples, n_features, i, j
        real(dp), allocatable :: centered(:,:)
        real(dp), allocatable :: means(:)

        n_samples = size(data,1)
        n_features = size(data,2)
        call require(n_samples > 1, 'covariance_matrix: need more than one sample')
        call require(size(cov,1) == n_features .and. size(cov,2) == n_features, 'covariance_matrix: output size mismatch')

        allocate(centered(n_samples, n_features), means(n_features))
        do j = 1, n_features
            means(j) = mean_vector(data(:,j))
        end do
        do i = 1, n_samples
            do j = 1, n_features
                centered(i,j) = data(i,j) - means(j)
            end do
        end do
        cov = matmul(transpose(centered), centered) / real(n_samples - 1, dp)
        deallocate(centered, means)
    end subroutine covariance_matrix
end module statistics
