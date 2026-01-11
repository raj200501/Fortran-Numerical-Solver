module test_linear_algebra_extras
    use kinds, only: dp
    use linear_algebra_extras, only: gram_schmidt, qr_solve, power_iteration
    use test_support, only: assert_near, assert_true, assert_vector_near
    implicit none
contains
    subroutine run_linear_algebra_extras_tests()
        real(dp), dimension(3,2) :: A
        real(dp), dimension(3,2) :: Q
        real(dp), dimension(2,2) :: R
        real(dp), dimension(3) :: b
        real(dp), dimension(2) :: x
        real(dp), dimension(2,2) :: M
        real(dp), dimension(2) :: v
        real(dp) :: eig
        integer :: iterations
        logical :: converged

        A(:,1) = (/1.0_dp, 0.0_dp, 0.0_dp/)
        A(:,2) = (/1.0_dp, 1.0_dp, 0.0_dp/)
        call gram_schmidt(A, Q, R)
        call assert_near(dot_product(Q(:,1), Q(:,2)), 0.0_dp, 1.0e-12_dp, 'gram_schmidt orthogonality')
        call assert_near(R(1,1), 1.0_dp, 1.0e-12_dp, 'gram_schmidt R(1,1)')

        b = (/1.0_dp, 2.0_dp, 3.0_dp/)
        call qr_solve(A, b, x)
        call assert_near(x(1), 1.0_dp, 1.0e-6_dp, 'qr_solve x1')
        call assert_near(x(2), 2.0_dp, 1.0e-6_dp, 'qr_solve x2')

        M = reshape((/2.0_dp, 1.0_dp, 1.0_dp, 2.0_dp/), (/2,2/))
        v = (/1.0_dp, 1.0_dp/)
        call power_iteration(M, v, 100, 1.0e-8_dp, eig, iterations, converged)
        call assert_true(converged, 'power_iteration converged')
        call assert_near(eig, 3.0_dp, 1.0e-5_dp, 'power_iteration eigenvalue')
    end subroutine run_linear_algebra_extras_tests
end module test_linear_algebra_extras
