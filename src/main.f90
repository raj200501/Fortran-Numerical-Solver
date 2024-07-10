program main
    use linear_solver
    use differential_solver
    use matrix_operations
    use utils
    implicit none

    ! Example of solving a system of linear equations
    call solve_linear_system_example()

    ! Example of solving a differential equation
    call solve_differential_equation_example()

    ! Example of matrix operations
    call perform_matrix_operations_example()

contains

    subroutine solve_linear_system_example()
        real(8), dimension(3,3) :: A
        real(8), dimension(3) :: b, x

        A = reshape((/3.0d0, -0.1d0, -0.2d0, 0.1d0, 7.0d0, -0.3d0, 0.3d0, -0.2d0, 10.0d0/), (/3,3/))
        b = (/7.85d0, -19.3d0, 71.4d0/)
        call solve_linear_system(A, b, x)
        print *, "Solution of the linear system: ", x
    end subroutine solve_linear_system_example

    subroutine solve_differential_equation_example()
        ! Differential equation example to be added here
    end subroutine solve_differential_equation_example

    subroutine perform_matrix_operations_example()
        real(8), dimension(3,3) :: A, B, C

        A = reshape((/1.0d0, 2.0d0, 3.0d0, 4.0d0, 5.0d0, 6.0d0, 7.0d0, 8.0d0, 9.0d0/), (/3,3/))
        B = reshape((/9.0d0, 8.0d0, 7.0d0, 6.0d0, 5.0d0, 4.0d0, 3.0d0, 2.0d0, 1.0d0/), (/3,3/))
        call matrix_multiply(A, B, C)
        print *, "Result of matrix multiplication: ", C
    end subroutine perform_matrix_operations_example

end program main
