# FortranNumericalSolver

**FortranNumericalSolver** is a numerical computing project built with modern
Fortran. It demonstrates common scientific computing workflows, including:

- Solving systems of linear equations (direct and iterative solvers)
- Solving differential equations (Euler and RK4)
- Matrix operations (multiplication, transpose, trace, norms, inversion)
- Root finding (bisection, Newton, secant)
- Numerical integration (trapezoidal, Simpson, adaptive)
- QR decomposition and eigenvalue estimation
- Simple optimization and time-series utilities

The repository is designed to be easy to build with a standard Fortran compiler
and to provide deterministic verification via `scripts/verify.sh`. When a
Fortran compiler is unavailable, a Python fallback implementation is used so the
examples and tests can still run. The bootstrap script will attempt to download
LFortran if `gfortran` is not installed; if downloads are blocked, the Python
fallback still works.

## Requirements

Primary (Fortran):

- GNU Fortran (`gfortran`)
- `make`
- `bash` (for helper scripts)

Fallback (Python only):

- Python 3.9+ (no third-party dependencies)

On Ubuntu for the Fortran toolchain:

```bash
sudo apt-get update
sudo apt-get install -y gfortran make
```

## Installation

```bash
git clone https://github.com/your-username/FortranNumericalSolver.git
cd FortranNumericalSolver
make
```

The compiled solver is located at `build/bin/solver`.

## Quickstart

Run the solver with built-in defaults:

```bash
./build/bin/solver
```

Run the solver with a configuration file:

```bash
./build/bin/solver examples/default_config.cfg
```

## Quickstart (Portable)

If you do not have a Fortran compiler installed, use the helper script which
falls back to the Python implementation:

```bash
./scripts/run.sh examples/default_config.cfg
```

## Verified Quickstart (Executed)

The following commands were executed successfully in this repository:

```bash
./scripts/run.sh examples/default_config.cfg
```

## Configuration

The solver accepts an optional configuration file of `key=value` pairs. The
default configuration is in `examples/default_config.cfg`. See:

- `docs/CONFIG.md`
- `docs/USAGE.md`

## Testing

Run unit tests:

```bash
make test
```

Run Python tests (used by the fallback implementation):

```bash
python -m unittest discover -s python_tests
```

## Verified Verification (Executed)

The canonical verification command is:

```bash
./scripts/verify.sh
```

This script performs:

- Clean build (when a Fortran compiler is available)
- Fortran unit tests (when available)
- Python unit tests
- Smoke test of the CLI output

## Scripts

- `scripts/run.sh`: build/run the solver or fallback Python implementation
- `scripts/verify.sh`: build, test, and smoke verification
- `scripts/bootstrap_fortran.sh`: locate or install a Fortran compiler

## Project Documentation

- `docs/ALGORITHMS.md`: numerical method descriptions
- `docs/API_REFERENCE.md`: public API overview
- `docs/ARCHITECTURE.md`: repository structure
- `docs/USAGE.md`: usage and troubleshooting
- `docs/CONFIG.md`: configuration format
- `docs/TESTING.md`: testing and verification
- `docs/EXAMPLES.md`: example workflows

## Contributing

We welcome contributions from everyone. Please read our
[CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
