module errors
    implicit none
contains
    subroutine require(condition, message)
        logical, intent(in) :: condition
        character(len=*), intent(in) :: message
        if (.not. condition) then
            write(*, '(a)') 'ERROR: ' // trim(message)
            error stop 1
        end if
    end subroutine require

    subroutine warn_if(condition, message)
        logical, intent(in) :: condition
        character(len=*), intent(in) :: message
        if (condition) then
            write(*, '(a)') 'WARNING: ' // trim(message)
        end if
    end subroutine warn_if
end module errors
