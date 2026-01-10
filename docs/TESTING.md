# Testing and Verification

This repository uses a lightweight Fortran test runner and a Python fallback
suite. Tests are deterministic and do not require network access.

## Fortran Test Runner

The Fortran test runner is built from these sources:

- `tests/test_support.f90` (assertions and reporting)
- `tests/test_runner.f90` (main entrypoint)
- Individual module test files

The runner prints a summary and exits non-zero if any assertion fails.

### Running Fortran Tests

```bash
make test
```

This builds the production code and test code, then runs `build/bin/test_runner`.

## Python Test Suite

The Python tests validate the fallback implementation. They are useful when
working on systems without a Fortran compiler.

### Running Python Tests

```bash
python -m unittest discover -s python_tests
```

## Verification Script

The canonical verification command is:

```bash
./scripts/verify.sh
```

It performs the following steps:

1. Clean build (if a Fortran compiler is available).
2. Compile the Fortran solver (if available).
3. Compile and run the Fortran unit tests (if available).
4. Run the Python unit tests.
5. Run a smoke test using `examples/default_config.cfg`.
6. Verify that expected output sections are present.
7. Perform a basic numerical sanity check on the ODE output.

## Adding Tests

When you add a new Fortran module, you should:

1. Create a new `tests/test_<module>.f90` file.
2. Add the test module to `tests/test_runner.f90`.
3. Add the new test source to the `Makefile` `TEST_SOURCES` list.

When you add a new Python module, you should:

1. Add a new file under `python_tests/`.
2. Use `unittest` and avoid external dependencies.

## Common Failures

- **Assertion failed:** The test output will include the failing assertion and
  expected/actual values. Investigate the specific function being tested.
- **Missing tests:** If `make test` cannot find a module, ensure the module is
  compiled by the Makefile in the correct order.

