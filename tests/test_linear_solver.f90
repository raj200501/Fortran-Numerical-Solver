program test_linear_solver
    use linear_solver
    implicit none

    real(8), dimension(3,3) :: A
    real(8), dimension(3) :: b, x

    A = reshape((/3.0d0, -0.1d0, -0.2d0, 0.1d0, 7.0d0, -0.3d0, 0.3d0, -0.2d0, 10.0d0/), (/3,3/))
    b = (/7.85d0, -19.3d0, 71.4d0/)
    call solve_linear_system(A, b, x)
    print *, "Test Solution of the linear system: ", x

end program test_linear_solver
