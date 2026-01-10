# API Reference

This file provides a structured reference for all public procedures and types.
It is intended as a quick lookup for developers.

## Module: `kinds`

### `dp`

- Type: `integer, parameter`
- Description: double-precision real kind (`real64`).

### `i32`

- Type: `integer, parameter`
- Description: 32-bit integer kind (`int32`).

## Module: `errors`

### `require(condition, message)`

- **Inputs**:
  - `condition` (`logical`): condition to enforce
  - `message` (`character(len=*)`): error message
- **Behavior**: prints `ERROR: <message>` and terminates if `condition` is false.

### `warn_if(condition, message)`

- **Inputs**:
  - `condition` (`logical`)
  - `message` (`character(len=*)`)
- **Behavior**: prints `WARNING: <message>` if `condition` is true.

## Module: `utils`

### `print_matrix(matrix, title)`

- **Inputs**:
  - `matrix` (`real(dp), dimension(:,:)`): matrix to print
  - `title` (optional string)

### `print_vector(vector, title)`

- **Inputs**:
  - `vector` (`real(dp), dimension(:)`): vector to print
  - `title` (optional string)

### `near(a, b, tol)`

- Returns `.true.` if `|a - b| <= tol`.

### `max_abs_diff(a, b)`

- Returns maximum absolute difference between two vectors.

### `max_abs_diff_matrix(a, b)`

- Returns maximum absolute difference between two matrices.

## Module: `data_io`

### `write_vector_csv(path, vector, header)`

- Writes a vector to a CSV file (one value per line).

### `write_matrix_csv(path, matrix, header)`

- Writes a matrix to a CSV file, row by row.

### `read_matrix(path, matrix)`

- Reads a whitespace-delimited matrix from a file into the provided array.

### `read_vector(path, vector)`

- Reads a whitespace-delimited vector from a file into the provided array.

## Module: `statistics`

### `mean_vector(x)`

- Returns the arithmetic mean.

### `variance_vector(x, sample)`

- Returns population variance by default, or sample variance if `sample=.true.`.

### `stddev_vector(x, sample)`

- Returns standard deviation.

### `covariance_matrix(data, cov)`

- Computes covariance matrix for data with samples as rows.

## Module: `interpolation`

### `linear_interpolate(x0, y0, x1, y1, x)`

- Returns linear interpolation at `x`.

### `lagrange_interpolate(x_data, y_data, x)`

- Returns the Lagrange interpolating polynomial value.

### `linspace(a, b, n, x)`

- Populates `x` with `n` evenly spaced points.

## Module: `matrix_operations`

### `matrix_multiply(A, B, C)`

- Computes `C = A * B`.

### `matrix_transpose(A, AT)`

- Computes transpose `AT = A^T`.

### `vector_dot(a, b)`

- Returns dot product.

### `vector_norm2(a)`

- Returns Euclidean norm.

### `identity_matrix(I)`

- Writes identity matrix to `I`.

### `matrix_add(A, B, C)`

- Computes `C = A + B`.

### `matrix_subtract(A, B, C)`

- Computes `C = A - B`.

### `matrix_trace(A)`

- Returns trace of `A`.

### `matrix_frobenius_norm(A)`

- Returns Frobenius norm.

### `matrix_copy(A, B)`

- Copies `A` into `B`.

### `matrix_scale(A, alpha, B)`

- Computes `B = alpha * A`.

### `matrix_row_swap(A, row1, row2)`

- Swaps rows in-place.

### `matrix_col_swap(A, col1, col2)`

- Swaps columns in-place.

### `determinant(A)`

- Returns determinant of a square matrix.

### `inverse_matrix(A, Ainv, info)`

- Computes inverse using LU decomposition.

### `lu_factor(A, L, U, piv, info)`

- Computes LU factorization with partial pivoting.

### `forward_substitution(L, b, y)`

- Solves lower triangular system.

### `backward_substitution(U, y, x)`

- Solves upper triangular system.

## Module: `linear_solver`

### `solve_linear_system(A, b, x, info)`

- Solves `A x = b` using LU decomposition.

### `jacobi_solver(A, b, x, max_iter, tol, iterations, converged)`

- Iterative Jacobi solver.

### `gauss_seidel_solver(A, b, x, max_iter, tol, iterations, converged)`

- Iterative Gauss-Seidel solver.

### `conjugate_gradient_solver(A, b, x, max_iter, tol, iterations, converged)`

- Conjugate gradient solver for SPD matrices.

## Module: `differential_solver`

### `euler_step(f, t, y, dt, y_next)`

- Single Euler step.

### `rk4_step(f, t, y, dt, y_next)`

- Single RK4 step.

### `solve_ivp(f, t0, t1, y0, dt, method, t_out, y_out)`

- Solves IVP over a time grid.

## Module: `root_finding`

### `bisection(f, a, b, tol, max_iter, root, iterations, converged)`

- Bisection method.

### `newton(f, df, x0, tol, max_iter, root, iterations, converged)`

- Newton method.

### `secant(f, x0, x1, tol, max_iter, root, iterations, converged)`

- Secant method.

## Module: `integration`

### `trapezoidal(f, a, b, n)`

- Composite trapezoidal rule.

### `simpson(f, a, b, n)`

- Composite Simpson rule.

### `adaptive_trapezoidal(f, a, b, tol, max_iter, iterations, converged)`

- Adaptive trapezoidal rule.

## Module: `linear_algebra_extras`

### `gram_schmidt(A, Q, R)`

- Classical Gram-Schmidt QR decomposition.

### `qr_solve(A, b, x)`

- Solves `A x = b` via QR decomposition.

### `power_iteration(A, x, max_iter, tol, eigenvalue, iterations, converged)`

- Dominant eigenvalue estimation.

## Module: `optimization`

### `gradient_descent(f, g, x0, alpha, tol, max_iter, x_opt, iterations, converged)`

- Gradient descent for scalar functions.

### `momentum_descent(f, g, x0, alpha, beta, tol, max_iter, x_opt, iterations, converged)`

- Momentum-enhanced gradient descent.

### `backtracking_line_search(f, g, x, direction, alpha0, rho, c, alpha)`

- Backtracking line search with Armijo condition.

## Module: `time_series`

### `moving_average(x, window, y)`

- Moving average smoothing.

### `exponential_smoothing(x, alpha, y)`

- Exponential smoothing.

### `mean_absolute_error(actual, predicted)`

- Mean absolute error.

### `mean_squared_error(actual, predicted)`

- Mean squared error.

### `root_mean_squared_error(actual, predicted)`

- Root mean squared error.

## Module: `config`

### Type: `solver_config`

Fields:

- `linear_size`
- `ode_t0`, `ode_t1`, `ode_dt`
- `ode_r`, `ode_k`
- `ode_method`

### `load_config(path, cfg)`

- Reads a configuration file and updates the fields of `cfg`.

