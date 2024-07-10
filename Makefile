FC = gfortran
FFLAGS = -O3 -Wall
OBJ = main.o linear_solver.o differential_solver.o matrix_operations.o utils.o
TARGET = solver

all: $(TARGET)

$(TARGET): $(OBJ)
	$(FC) -o $@ $^

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f *.o *.mod $(TARGET)
