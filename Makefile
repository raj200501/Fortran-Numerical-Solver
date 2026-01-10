FC = gfortran
FFLAGS = -O2 -Wall -Wextra -fcheck=all -J$(OBJ_DIR) -I$(OBJ_DIR)
SRC_DIR = src
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin
TARGET = $(BIN_DIR)/solver

SOURCES = \
	$(SRC_DIR)/kinds.f90 \
	$(SRC_DIR)/errors.f90 \
	$(SRC_DIR)/utils.f90 \
	$(SRC_DIR)/data_io.f90 \
	$(SRC_DIR)/statistics.f90 \
	$(SRC_DIR)/interpolation.f90 \
	$(SRC_DIR)/root_finding.f90 \
	$(SRC_DIR)/integration.f90 \
	$(SRC_DIR)/linear_algebra_extras.f90 \
	$(SRC_DIR)/optimization.f90 \
	$(SRC_DIR)/time_series.f90 \
	$(SRC_DIR)/matrix_operations.f90 \
	$(SRC_DIR)/linear_solver.f90 \
	$(SRC_DIR)/differential_solver.f90 \
	$(SRC_DIR)/config.f90 \
	$(SRC_DIR)/main.f90

OBJECTS = $(SOURCES:$(SRC_DIR)/%.f90=$(OBJ_DIR)/%.o)

.PHONY: all clean test

all: $(TARGET)

$(TARGET): $(OBJECTS) | $(BIN_DIR)
	$(FC) $(FFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90 | $(OBJ_DIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BUILD_DIR)

TEST_SOURCES = \
	tests/test_support.f90 \
	tests/test_linear_solver.f90 \
	tests/test_matrix_operations.f90 \
	tests/test_differential_solver.f90 \
	tests/test_config.f90 \
	tests/test_root_finding.f90 \
	tests/test_integration.f90 \
	tests/test_linear_algebra_extras.f90 \
	tests/test_statistics_interpolation.f90 \
	tests/test_optimization_time_series.f90 \
	tests/test_runner.f90

TEST_OBJECTS = $(TEST_SOURCES:tests/%.f90=$(OBJ_DIR)/tests_%.o)
TEST_TARGET = $(BIN_DIR)/test_runner

$(OBJ_DIR)/tests_%.o: tests/%.f90 | $(OBJ_DIR)
	$(FC) $(FFLAGS) -I$(OBJ_DIR) -c $< -o $@

$(TEST_TARGET): $(OBJECTS) $(TEST_OBJECTS) | $(BIN_DIR)
	$(FC) $(FFLAGS) -o $@ $^

test: $(TEST_TARGET)
	$(TEST_TARGET)
