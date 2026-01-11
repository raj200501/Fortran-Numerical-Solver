# Contributing to FortranNumericalSolver

Thank you for considering a contribution! This project aims to be a clean and
accessible Fortran codebase that demonstrates core numerical methods. The
guidelines below help keep the repository consistent and maintainable.

## Development Setup

1. Install GNU Fortran (`gfortran`) and `make`.
2. Clone the repository and build the solver:

```bash
git clone https://github.com/your-username/FortranNumericalSolver.git
cd FortranNumericalSolver
make
```

## Branching and Commits

- Use short-lived branches for changes.
- Keep commits focused (one logical change per commit where possible).
- Write descriptive commit messages.

## Code Style

- Use `implicit none` in all Fortran units.
- Prefer `real(dp)` from `kinds` for floating-point values.
- Validate input sizes using `errors.require`.
- Keep procedures small and single-purpose.
- Avoid global state unless it is truly necessary.

## Adding a New Module

1. Create a new module in `src/`.
2. Add the module to the `SOURCES` list in the `Makefile`.
3. Create a corresponding test module in `tests/`.
4. Register the test in `tests/test_runner.f90` and the `Makefile`.
5. Update documentation in `docs/` if the change is user-facing.

## Testing

Run all tests and verification before submitting a change:

```bash
make test
./scripts/verify.sh
```

All tests must pass. If your change alters output format, update the smoke
checks in `scripts/verify.sh` accordingly.

## Documentation

If you add a new algorithm or update existing behavior:

- Update `docs/ALGORITHMS.md` with method descriptions.
- Update `docs/API_REFERENCE.md` with the new public procedure.
- Update `README.md` if the behavior is user-visible.

## Reporting Issues

When filing an issue, include:

- The command you ran
- The exact output (or error message)
- Your compiler version (`gfortran --version`)
- Your operating system

This information helps maintainers reproduce and diagnose the issue quickly.

