module test_support
    use kinds, only: dp
    implicit none
    integer :: tests_run = 0
    integer :: tests_failed = 0
contains
    subroutine assert_true(condition, message)
        logical, intent(in) :: condition
        character(len=*), intent(in) :: message
        tests_run = tests_run + 1
        if (.not. condition) then
            tests_failed = tests_failed + 1
            write(*,'(a)') 'ASSERT FAILED: ' // trim(message)
        end if
    end subroutine assert_true

    subroutine assert_near(a, b, tol, message)
        real(dp), intent(in) :: a, b, tol
        character(len=*), intent(in) :: message
        tests_run = tests_run + 1
        if (abs(a - b) > tol) then
            tests_failed = tests_failed + 1
            write(*,'(a,f12.6,a,f12.6)') 'ASSERT FAILED: ' // trim(message) // ' expected ', b, ' got ', a
        end if
    end subroutine assert_near

    subroutine assert_vector_near(a, b, tol, message)
        real(dp), dimension(:), intent(in) :: a, b
        real(dp), intent(in) :: tol
        character(len=*), intent(in) :: message
        integer :: i
        tests_run = tests_run + 1
        if (size(a) /= size(b)) then
            tests_failed = tests_failed + 1
            write(*,'(a)') 'ASSERT FAILED: ' // trim(message) // ' size mismatch'
            return
        end if
        do i = 1, size(a)
            if (abs(a(i) - b(i)) > tol) then
                tests_failed = tests_failed + 1
                write(*,'(a,i0,a,f12.6,a,f12.6)') 'ASSERT FAILED: ' // trim(message) // ' idx ', i, ' expected ', b(i), ' got ', a(i)
                exit
            end if
        end do
    end subroutine assert_vector_near

    subroutine report_and_exit()
        write(*,'(a,i0)') 'Tests run: ', tests_run
        if (tests_failed == 0) then
            write(*,'(a)') 'All tests passed.'
        else
            write(*,'(a,i0)') 'Tests failed: ', tests_failed
            error stop 1
        end if
    end subroutine report_and_exit
end module test_support
