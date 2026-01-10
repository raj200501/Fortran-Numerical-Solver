# Algorithms and Numerical Methods

This document describes the numerical methods implemented in this repository. It is intended to
be a reference for contributors who want to understand the behavior, assumptions, and numerical
trade-offs of each solver. The examples assume double precision (`real64` via `kinds.f90`).

## Table of Contents

1. [Linear Systems](#linear-systems)
2. [Matrix Operations](#matrix-operations)
3. [Differential Equations](#differential-equations)
4. [Root Finding](#root-finding)
5. [Numerical Integration](#numerical-integration)
6. [QR Decomposition and Eigenvalues](#qr-decomposition-and-eigenvalues)
7. [Optimization](#optimization)
8. [Statistics](#statistics)
9. [Interpolation](#interpolation)
10. [Time Series Utilities](#time-series-utilities)
11. [Data I/O](#data-io)

---

## Linear Systems

### LU Decomposition Solver

File: `src/linear_solver.f90` (procedure `solve_linear_system`).

We solve systems `A x = b` using an LU factorization with partial pivoting. The algorithm
factorizes the matrix into a lower triangular matrix `L` and an upper triangular matrix `U`
with a permutation vector `piv` that tracks row swaps. The following steps are applied:

1. Compute `L`, `U`, and `piv` using `lu_factor`.
2. Apply the permutation to the right-hand side `b` (creating `b_p`).
3. Solve `L y = b_p` via forward substitution.
4. Solve `U x = y` via back substitution.

Key properties:

- **Stability:** Partial pivoting is used to reduce numerical instability.
- **Complexity:** O(n^3) factorization and O(n^2) substitution.
- **Failure modes:** Singular matrices lead to a nonzero `info` code. The solver returns
  a zero vector and `info` set to the index of the failing pivot.

#### Forward Substitution

Given a lower triangular matrix `L` with non-zero diagonal:

```
for i = 1..n
  y(i) = (b(i) - sum_{j=1}^{i-1} L(i,j) y(j)) / L(i,i)
```

#### Backward Substitution

Given an upper triangular matrix `U` with non-zero diagonal:

```
for i = n..1
  x(i) = (y(i) - sum_{j=i+1}^{n} U(i,j) x(j)) / U(i,i)
```

### Iterative Solvers

Iterative solvers are useful for large, sparse, or diagonally dominant systems. The
implementation includes:

- Jacobi (`jacobi_solver`)
- Gauss-Seidel (`gauss_seidel_solver`)
- Conjugate Gradient (`conjugate_gradient_solver`)

#### Jacobi Method

Jacobi updates all components from the previous iteration:

```
for i = 1..n
  x_new(i) = (b(i) - sum_{j!=i} A(i,j) x_old(j)) / A(i,i)
```

The method converges if the matrix is strictly diagonally dominant or symmetric positive
Definite with a spectral radius condition. We use a tolerance on the norm of
`x_new - x_old`.

#### Gauss-Seidel Method

Gauss-Seidel uses the latest updates immediately:

```
for i = 1..n
  x(i) = (b(i) - sum_{j< i} A(i,j) x(j) - sum_{j>i} A(i,j) x_old(j)) / A(i,i)
```

This generally converges faster than Jacobi when conditions are met.

#### Conjugate Gradient Method

Conjugate gradient solves symmetric positive definite systems using orthogonal search
Directions. The algorithm is:

```
Initialize: r0 = b - A x0
p0 = r0
for k = 0..max_iter:
  alpha = (r_k^T r_k) / (p_k^T A p_k)
  x_{k+1} = x_k + alpha p_k
  r_{k+1} = r_k - alpha A p_k
  if ||r_{k+1}|| < tol stop
  beta = (r_{k+1}^T r_{k+1}) / (r_k^T r_k)
  p_{k+1} = r_{k+1} + beta p_k
```

Conjugate gradient converges in at most `n` steps in exact arithmetic, but often needs
far fewer iterations in practice.

---

## Matrix Operations

File: `src/matrix_operations.f90`

### Matrix Multiplication

`matrix_multiply` uses Fortran `matmul`, providing optimized performance with
compiler-optimized BLAS routines when available.

### Transpose

`matrix_transpose` calls intrinsic `transpose` but validates dimensions first.

### Trace and Frobenius Norm

- Trace: `sum_{i=1}^n A(i,i)`.
- Frobenius norm: `sqrt(sum_{i,j} A(i,j)^2)`.

### Determinant via LU

The determinant is the product of diagonal elements of `U` from the LU factorization,
with a sign adjustment based on the parity of the pivot permutation.

### Inverse via LU

To compute `A^{-1}` we solve `A X = I` one column at a time:

1. Factor `A = L U`.
2. For each column `e_i` of the identity matrix, solve:
   - `L y = e_i`
   - `U x_i = y`
3. Assemble the columns `x_i` into the inverse matrix.

This is more stable than the naive adjugate approach, but still less stable than
solving `A x = b` directly when only a solution is needed.

---

## Differential Equations

File: `src/differential_solver.f90`

We solve initial value problems (IVP) of the form:

```
 dy/dt = f(t, y)
 y(t0) = y0
```

Two explicit integrators are provided:

- Forward Euler (`euler_step`)
- Runge-Kutta 4th order (`rk4_step`)

### Forward Euler

```
y_{n+1} = y_n + dt * f(t_n, y_n)
```

Euler is first-order accurate and can be unstable for stiff problems unless `dt` is very
small.

### Runge-Kutta (RK4)

RK4 is fourth-order accurate and considerably more stable for a wide range of problems.
The four intermediate stages are:

```
k1 = f(t, y)
k2 = f(t + dt/2, y + dt/2 * k1)
k3 = f(t + dt/2, y + dt/2 * k2)
k4 = f(t + dt, y + dt * k3)
```

Then:

```
y_{n+1} = y_n + dt/6 * (k1 + 2 k2 + 2 k3 + k4)
```

### Time Grid

We compute `n_steps = int((t1 - t0)/dt) + 1` and generate a uniform time grid.
The solver validates that `t_out` and `y_out` are correctly sized to avoid memory
Errors.

---

## Root Finding

File: `src/root_finding.f90`

We solve `f(x) = 0` for scalar functions using three classic methods.

### Bisection

Bisection requires a bracket `[a, b]` with `f(a) * f(b) <= 0`. The method repeatedly
splits the interval and selects the sub-interval that still brackets a root.

Convergence is guaranteed for continuous functions; the error decreases by half each
iteration.

### Newton's Method

Newton's method uses the derivative `f'(x)` to obtain quadratic convergence near
simple roots:

```
x_{k+1} = x_k - f(x_k) / f'(x_k)
```

The method can diverge if the initial guess is poor or if `f'(x)` is near zero. We
fail fast if a zero derivative is encountered.

### Secant Method

The secant method approximates the derivative using a finite difference between the
latest two iterates:

```
x_{k+1} = x_k - f(x_k) (x_k - x_{k-1}) / (f(x_k) - f(x_{k-1}))
```

It is superlinear and typically faster than bisection but less stable.

---

## Numerical Integration

File: `src/integration.f90`

We compute definite integrals:

```
I = \int_a^b f(x) dx
```

### Composite Trapezoidal Rule

Split the interval into `n` subintervals of width `h`:

```
I ≈ h [ (f(a) + f(b))/2 + sum_{i=1}^{n-1} f(a + i h) ]
```

The error is `O(h^2)` for sufficiently smooth functions.

### Composite Simpson's Rule

Simpson's rule uses quadratic approximations over pairs of subintervals (hence `n`
must be even):

```
I ≈ (h/3) [ f(a) + f(b) + 4 sum_{i odd} f(a + i h) + 2 sum_{i even} f(a + i h) ]
```

The error is `O(h^4)` for smooth functions.

### Adaptive Trapezoidal

The adaptive version doubles `n` until the estimated change is below a tolerance:

```
repeat
  n = 2 n
  I_new = trapezoidal(f, a, b, n)
until |I_new - I_old| < tol
```

This is not a full adaptive integrator but provides a simple convergence heuristic.

---

## QR Decomposition and Eigenvalues

File: `src/linear_algebra_extras.f90`

### Gram-Schmidt QR

We use classical Gram-Schmidt to decompose `A` into `Q R` where `Q` has orthonormal
columns and `R` is upper triangular.

Given columns `a1..an` of `A`:

```
for j = 1..n
  v = a_j
  for i = 1..j-1
    r_{i,j} = q_i^T a_j
    v = v - r_{i,j} q_i
  end
  r_{j,j} = ||v||
  q_j = v / r_{j,j}
```

We assert that `r_{j,j} > 0` (linearly independent columns).

### QR Solve

Given `A x = b`, after `A = Q R`:

```
R x = Q^T b
```

We then solve the triangular system by back substitution.

### Power Iteration

Power iteration estimates the dominant eigenvalue and eigenvector by repeated
multiplication:

```
for k in 1..max_iter
  y = A x
  x = y / ||y||
  lambda = x^T A x
```

Convergence requires that the dominant eigenvalue has greater magnitude than the rest
and that the starting vector has a component along the dominant eigenvector.

---

## Optimization

File: `src/optimization.f90`

The optimization module focuses on scalar optimization problems using gradient-based
methods.

### Gradient Descent

```
x_{k+1} = x_k - alpha * grad(x_k)
```

The step size `alpha` is fixed. For quadratic objectives, convergence is guaranteed
if `alpha` is sufficiently small. The algorithm terminates when either the step size
or the gradient magnitude falls below `tol`.

### Momentum Descent

Momentum accelerates convergence by adding a velocity term:

```
v_{k+1} = beta * v_k + alpha * grad(x_k)
 x_{k+1} = x_k - v_{k+1}
```

This can reduce oscillations and speed up convergence for ill-conditioned objectives.

### Backtracking Line Search

Backtracking chooses a step size `alpha` that satisfies the Armijo condition:

```
f(x + alpha d) <= f(x) + c alpha grad(x)^T d
```

We shrink `alpha` by a factor `rho` until the condition holds or until `alpha` is very
small. This provides a robust step size for gradient-based methods.

---

## Statistics

File: `src/statistics.f90`

We provide basic statistics for vectors and covariance matrices for datasets.

### Mean

```
mu = (1/n) sum x_i
```

### Variance

Population variance:

```
var = (1/n) sum (x_i - mu)^2
```

Sample variance (unbiased):

```
var = (1/(n-1)) sum (x_i - mu)^2
```

### Standard Deviation

Standard deviation is `sqrt(variance)`.

### Covariance Matrix

For data matrix `X` with `n` samples and `d` features, we center each column and
compute:

```
Cov = (1/(n-1)) X_centered^T X_centered
```

---

## Interpolation

File: `src/interpolation.f90`

### Linear Interpolation

Given two points `(x0, y0)` and `(x1, y1)`:

```
y = y0 + (y1 - y0) * (x - x0) / (x1 - x0)
```

### Lagrange Polynomial Interpolation

Given `n` data points `(x_i, y_i)`, we compute:

```
P(x) = sum_{i=1}^n y_i * L_i(x)
```

where

```
L_i(x) = prod_{j!=i} (x - x_j) / (x_i - x_j)
```

This yields an exact polynomial passing through all points, but can be unstable for
large `n` (Runge's phenomenon).

### Linspace

Utility to create evenly spaced samples:

```
x(i) = a + (b - a) * (i - 1)/(n - 1)
```

---

## Time Series Utilities

File: `src/time_series.f90`

### Moving Average

The moving average smooths a sequence using a fixed window size. For each index `i`,
we average the last `window` elements. For `i < window` we use the available prefix.

### Exponential Smoothing

Exponential smoothing is defined as:

```
y_1 = x_1
 y_i = alpha * x_i + (1 - alpha) * y_{i-1}
```

This produces a low-pass filtered signal.

### Error Metrics

We compute common error measures:

- Mean Absolute Error (MAE): `mean(|y - y_hat|)`
- Mean Squared Error (MSE): `mean((y - y_hat)^2)`
- Root MSE (RMSE): `sqrt(MSE)`

---

## Data I/O

File: `src/data_io.f90`

Data I/O utilities are intended for small fixtures and outputs used in tests or
local experiments.

### CSV Writing

- `write_vector_csv` writes a vector as a column, with an optional header line.
- `write_matrix_csv` writes a matrix row-by-row, comma-separated.

### Plain Text Reading

- `read_matrix` reads a fixed-size matrix from a whitespace-delimited file.
- `read_vector` reads a fixed-size vector from a whitespace-delimited file.

These routines do not attempt to auto-detect sizes or handle ragged inputs; callers
must allocate the output arrays with the correct dimensions.

---

## Numerical Precision and Stability Notes

- All computations use `real64` (`dp`). This is adequate for most demonstration
  and educational workloads but may not be sufficient for highly ill-conditioned
  problems.
- The LU implementation performs partial pivoting but does not use scaling or
  iterative refinement.
- Iterative methods assume well-conditioned or diagonally dominant matrices
  for convergence.
- Differential equation solvers are explicit and therefore not suitable for
  stiff problems without small time steps.

---

## Recommended Usage Patterns

- **Linear system solving:** Prefer `solve_linear_system` for dense small matrices;
  use iterative solvers if you wish to explore convergence behavior.
- **Differential equations:** Use `rk4` for accuracy unless you explicitly need
  Euler for demonstration purposes.
- **Root finding:** Use bisection if you can bracket a root and need certainty;
  use Newton or secant when derivative information or fast convergence is desired.
- **Integration:** Use Simpson's rule for smooth functions; adaptive trapezoidal
  is a simple fallback when you are unsure of smoothness.

---

## Extending the Algorithms

When adding new numerical routines, consider the following:

1. Validate input dimensions and parameters.
2. Provide clear error messages using `errors.require`.
3. Add unit tests in `tests/` that exercise both success and error conditions.
4. Document the method and assumptions here.

