# Examples and Workflows

This document provides concrete end-to-end workflows using the solver.

## Example 1: Linear System Solvers

The built-in demo solves:

```
A = [ 3.0  -0.1  -0.2 ]
    [ 0.1   7.0  -0.3 ]
    [ 0.3  -0.2  10.0 ]

b = [ 7.85, -19.3, 71.4 ]
```

The expected solution is:

```
x = [ 3.0, -2.5, 7.0 ]
```

The solver prints the solution for four methods:

- LU decomposition
- Jacobi iteration
- Gauss-Seidel iteration
- Conjugate gradient

The iterative methods report convergence status and iteration count. If the
matrix is not diagonally dominant or symmetric positive definite, convergence
may fail; this is reported in the output.

### How to run

```
./build/bin/solver examples/default_config.cfg
```

### Expected output (excerpt)

```
Solution of the linear system (LU):
  [1] = 3.0000
  [2] = -2.5000
  [3] = 7.0000
Jacobi converged: T in iterations: 19
Gauss-Seidel converged: T in iterations: 9
Conjugate Gradient converged: T in iterations: 6
```

## Example 2: Logistic Growth ODE

The ODE is:

```
 dy/dt = r y (1 - y/K)
```

Parameters are set by the config file:

```
ode_r=1.5
ode_k=10.0
ode_t0=0.0
ode_t1=2.0
ode_dt=0.1
ode_method=rk4
```

The solver prints the first and last time points so you can validate that
`y(t)` grows towards the carrying capacity `K`.

### Expected behavior

- `y(0) = 0.5` (fixed initial condition)
- `y(t)` should increase but remain below `K`

### Switching to Euler

```
ode_method=euler
```

Euler will produce a slightly different final value due to the lower-order
method.

## Example 3: Matrix Operations

Matrix operations include:

- Matrix multiplication (`A * B`)
- Transpose (`A^T`)
- Trace and Frobenius norm

These are printed for two small matrices in the demo. You can change the
matrix values by editing `src/main.f90` for experimentation.

## Example 4: Root Finding

Although root finding is not currently invoked in `main`, it is tested via
unit tests. Example usage from a hypothetical driver program:

```
call bisection(f, 0.0_dp, 2.0_dp, 1.0e-8_dp, 100, root, iters, converged)
```

This solves `x^2 - 2 = 0`, yielding `sqrt(2)`.

## Example 5: Numerical Integration

Compute:

```
∫_0^1 x^2 dx = 1/3
```

Examples:

- Trapezoidal rule with `n=1000`
- Simpson's rule with `n=100`
- Adaptive trapezoidal with `tol=1e-6`

All of these are covered in unit tests. When adding new integration routines,
use similarly simple functions with known analytic integrals.

## Example 6: QR Solve

Given an overdetermined system `A x = b`, you can solve the least squares
problem with QR decomposition. The test case uses:

```
A = [1 1]
    [0 1]
    [0 0]

b = [1, 2, 3]
```

The solution approximates `x = [1, 2]`.

## Example 7: Optimization

Gradient descent and momentum are demonstrated in unit tests on the quadratic
function:

```
f(x) = (x - 2)^2
```

The optimizer should converge to `x = 2` for a sufficiently small step size.

## Example 8: Time Series Smoothing

Given a series `x`, the moving average and exponential smoothing functions can
be used to smooth noisy data. Example series:

```
1, 2, 3, 4, 5
```

Moving average with window 3 yields:

```
1, 1.5, 2, 3, 4
```

Exponential smoothing with `alpha=0.5` yields:

```
1, 1.5, 2.25, 3.125, 4.0625
```

## Example 9: Writing Data

The `data_io` module can write vectors and matrices to CSV for downstream
analysis. Example usage:

```
call write_vector_csv('output.csv', vector, 'value')
```

The file will have a header line followed by a column of values.

---

## Notes for Contributors

- Always update the verification script if output format changes.
- Keep example outputs in sync with `src/main.f90`.
- Add new examples to this document as new modules are added.

