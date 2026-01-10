module data_io
    use kinds, only: dp
    use errors, only: require
    implicit none
contains
    subroutine write_vector_csv(path, vector, header)
        character(len=*), intent(in) :: path
        real(dp), dimension(:), intent(in) :: vector
        character(len=*), intent(in), optional :: header
        integer :: i, unit
        open(newunit=unit, file=trim(path), status='replace', action='write')
        if (present(header)) then
            write(unit, '(a)') trim(header)
        end if
        do i = 1, size(vector)
            write(unit, '(f16.8)') vector(i)
        end do
        close(unit)
    end subroutine write_vector_csv

    subroutine write_matrix_csv(path, matrix, header)
        character(len=*), intent(in) :: path
        real(dp), dimension(:,:), intent(in) :: matrix
        character(len=*), intent(in), optional :: header
        integer :: i, j, unit
        open(newunit=unit, file=trim(path), status='replace', action='write')
        if (present(header)) then
            write(unit, '(a)') trim(header)
        end if
        do i = 1, size(matrix,1)
            do j = 1, size(matrix,2)
                if (j < size(matrix,2)) then
                    write(unit, '(f16.8,a)', advance='no') matrix(i,j), ','
                else
                    write(unit, '(f16.8)') matrix(i,j)
                end if
            end do
        end do
        close(unit)
    end subroutine write_matrix_csv

    subroutine read_matrix(path, matrix)
        character(len=*), intent(in) :: path
        real(dp), dimension(:,:), intent(out) :: matrix
        integer :: unit, ios, i, j
        open(newunit=unit, file=trim(path), status='old', action='read', iostat=ios)
        call require(ios == 0, 'read_matrix: failed to open file')
        do i = 1, size(matrix,1)
            read(unit, *, iostat=ios) (matrix(i,j), j = 1, size(matrix,2))
            call require(ios == 0, 'read_matrix: failed to read row')
        end do
        close(unit)
    end subroutine read_matrix

    subroutine read_vector(path, vector)
        character(len=*), intent(in) :: path
        real(dp), dimension(:), intent(out) :: vector
        integer :: unit, ios, i
        open(newunit=unit, file=trim(path), status='old', action='read', iostat=ios)
        call require(ios == 0, 'read_vector: failed to open file')
        do i = 1, size(vector)
            read(unit, *, iostat=ios) vector(i)
            call require(ios == 0, 'read_vector: failed to read value')
        end do
        close(unit)
    end subroutine read_vector
end module data_io
