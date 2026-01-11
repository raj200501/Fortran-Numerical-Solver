# Architecture Overview

This repository is organized to keep the Fortran source code, build artifacts,
and tests clearly separated. The goal is to make the project approachable for
both scientific computing practitioners and maintainers who may be newer to
Fortran ecosystems.

## Repository Layout

```
.
├── src/                 # Fortran source modules and main program
├── tests/               # Unit test modules and test runner
├── examples/            # Sample configuration files
├── scripts/             # Helper scripts for running and verification
├── docs/                # Project documentation
├── .github/workflows/   # CI configuration
├── Makefile             # Build and test entrypoints
└── README.md            # Project overview and quickstart
```

## Build Flow

The Makefile uses a straightforward build pipeline:

1. Each Fortran source file in `src/` is compiled into an object file under
   `build/obj/`.
2. Object files are linked into the `build/bin/solver` executable.
3. Tests are compiled and linked together with the production modules into
   `build/bin/test_runner`.

This approach avoids polluting the source directory with `.o` and `.mod` files
and keeps the build clean.

## Module Dependencies

The modules are arranged to avoid circular dependencies:

- `kinds` and `errors` are foundational.
- Utility modules (`utils`, `data_io`, `statistics`, `interpolation`) depend on
  `kinds` and `errors` only.
- Computational modules (`matrix_operations`, `linear_solver`,
  `differential_solver`, `root_finding`, `integration`, `linear_algebra_extras`,
  `optimization`, `time_series`) build on the utilities.
- `config` is independent of computational modules, used by `main`.
- `main` orchestrates the demo run and does not implement algorithms directly.

This structure keeps each module focused and testable.

## Error Handling Strategy

The `errors` module provides a `require` subroutine that terminates execution
with a clear error message. This mirrors common practices in scientific
computing where invalid numeric input should fail fast and loudly.

We use explicit validation in each module to ensure:

- Matrix dimensions are consistent.
- Time step sizes and tolerances are positive.
- Inputs that would cause division by zero are rejected.

## Testing Strategy

Each module has one or more unit tests that focus on deterministic, small-scale
examples with known outcomes. For example:

- Linear solvers are tested against a known 3x3 system with a closed-form
  solution.
- RK4 integration is validated against `exp(t)` which has a closed-form
  solution.
- Root finding uses `x^2 - 2`, verifying convergence to `sqrt(2)`.

Integration tests are handled by the `scripts/verify.sh` script, which runs the
solver with a known configuration and checks for expected output sections.

## Performance Notes

The project is not designed as a high-performance framework. It is intended as
an educational and demonstrative codebase. Nevertheless, there are practical
performance considerations:

- Using `matmul` allows compilers to leverage optimized BLAS implementations.
- Avoiding dynamic memory allocation inside tight loops improves performance.
- Keeping algorithmic complexity visible aids learning and debugging.

## Extensibility Guidelines

When adding new algorithms or modules:

1. Keep interfaces small and focused.
2. Validate inputs and fail fast with clear errors.
3. Provide unit tests for at least one canonical case and one edge case.
4. Update documentation to explain algorithm choices and limitations.

