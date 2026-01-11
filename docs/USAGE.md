# Usage Guide

This guide explains how to configure, run, and interpret the output of
FortranNumericalSolver. It complements the README and focuses on details that
contributors and maintainers might need.

## Contents

1. [Build Artifacts](#build-artifacts)
2. [Running the Solver](#running-the-solver)
3. [Configuration File Format](#configuration-file-format)
4. [Output Interpretation](#output-interpretation)
5. [Examples](#examples)
6. [Troubleshooting](#troubleshooting)

---

## Build Artifacts

The Makefile produces output in the `build/` directory to keep the repository
clean:

- `build/obj`: object files (`.o`) and module interface files (`.mod`)
- `build/bin/solver`: the main solver executable
- `build/bin/test_runner`: the unit test runner

If you want to remove all build artifacts, run:

```bash
make clean
```

---

## Running the Solver

The solver accepts an optional configuration file. When no configuration is
provided, a built-in default configuration is used.

### Basic Run (Fortran)

```bash
./build/bin/solver
```

### Run With a Config File (Fortran)

```bash
./build/bin/solver examples/default_config.cfg
```

### Portable Run (Fallback Python)

If you do not have a Fortran compiler available, use the helper script that
falls back to the Python implementation:

```bash
./scripts/run.sh examples/default_config.cfg
```

The configuration file is plain text with `key=value` pairs. Unknown keys are
ignored so you can add comments or additional metadata without breaking the
parser.

---

## Configuration File Format

Configuration is read by `src/config.f90` (Fortran) and `python_solver/config.py`
(Python) and supports the following keys:

| Key | Type | Description | Example |
| --- | --- | --- | --- |
| `linear_size` | integer | Size of the linear system demo | `3` |
| `ode_t0` | real | Start time for IVP | `0.0` |
| `ode_t1` | real | End time for IVP | `2.0` |
| `ode_dt` | real | Time step size | `0.1` |
| `ode_r` | real | Growth rate for logistic model | `1.5` |
| `ode_k` | real | Carrying capacity | `10.0` |
| `ode_method` | string | ODE method (`euler` or `rk4`) | `rk4` |

Sample configuration files are provided in `examples/` and `tests/fixtures/`.

---

## Output Interpretation

The solver prints three groups of results:

1. **Linear system solutions**
2. **Differential equation solution sample**
3. **Matrix operations**

Each section is labeled so you can parse outputs in a smoke test or integration
check. The example output structure looks like:

```
Solution of the linear system (LU):
  [1] = 3.0000
  [2] = -2.5000
  [3] = 7.0000
Jacobi converged: T in iterations: 19
...
Differential equation (logistic growth) sample:
  t       y
  0.00     0.50000
  2.00     1.82499
Result of matrix multiplication:
  30.0000 24.0000 18.0000
  84.0000 69.0000 54.0000
  138.0000 114.0000 90.0000
Trace of A:  15.0000
Frobenius norm of A:  16.8819
```

The solver intentionally prints the first and last time points of the ODE to
keep the output concise while still verifying the behavior.

---

## Examples

### Modify the ODE Method

The logistic growth example is controlled by `ode_method`. Edit the configuration
file to switch between Euler and RK4.

```
ode_method=euler
```

The Euler method will generally yield a larger numerical error compared to RK4
for the same step size, which is a good way to observe the effect of numerical
methods.

### Change the Time Step

Smaller `ode_dt` increases accuracy but also increases runtime:

```
ode_dt=0.05
```

### Use a Different Carrying Capacity

```
ode_k=20.0
```

You should observe a larger final value for the logistic solution.

---

## Troubleshooting

### Build Errors (Missing gfortran)

If `make` fails with a message like `gfortran: command not found`, use the
portable script instead:

```bash
./scripts/run.sh examples/default_config.cfg
```

The script will use a Python fallback implementation.

### Solver Reports "unknown method"

The ODE solver only recognizes `euler` and `rk4`. Ensure the value in the config
file matches one of these exactly.

### Output Is Missing a Section

If the solver exits early or output is truncated, check for errors printed with the
`ERROR:` prefix. These come from the `errors` module and indicate invalid input
parameters (e.g., a non-square matrix).

