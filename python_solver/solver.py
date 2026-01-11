from __future__ import annotations

import sys

from python_solver.config import SolverConfig, load_config
from python_solver.linear_solver import (
    conjugate_gradient,
    gauss_seidel,
    jacobi,
    solve_linear_system,
)
from python_solver.matrix_ops import matmul, transpose, trace, frobenius_norm
from python_solver.ode import solve_ivp
from python_solver.utils import print_matrix, print_vector


def run_linear_system_example(cfg: SolverConfig) -> None:
    if cfg.linear_size != 3:
        raise ValueError("current demo expects linear_size = 3")
    a = [
        [3.0, -0.1, -0.2],
        [0.1, 7.0, -0.3],
        [0.3, -0.2, 10.0],
    ]
    b = [7.85, -19.3, 71.4]

    x, info = solve_linear_system(a, b)
    if info != 0:
        print(f"LU solver failed, info = {info}")
    else:
        print_vector(x, "Solution of the linear system (LU):")

    x, iterations, converged = jacobi(a, b, 200, 1.0e-8)
    print(f"Jacobi converged: {converged} in iterations: {iterations}")
    print_vector(x, "Solution of the linear system (Jacobi):")

    x, iterations, converged = gauss_seidel(a, b, 200, 1.0e-10)
    print(f"Gauss-Seidel converged: {converged} in iterations: {iterations}")
    print_vector(x, "Solution of the linear system (Gauss-Seidel):")

    x, iterations, converged = conjugate_gradient(a, b, 200, 1.0e-10)
    print(f"Conjugate Gradient converged: {converged} in iterations: {iterations}")
    print_vector(x, "Solution of the linear system (Conjugate Gradient):")


def logistic_rhs(cfg: SolverConfig):
    def rhs(t: float, y: list[float]) -> list[float]:
        return [cfg.ode_r * y[0] * (1.0 - y[0] / cfg.ode_k)]

    return rhs


def run_differential_equation_example(cfg: SolverConfig) -> None:
    t_values, y_values = solve_ivp(
        logistic_rhs(cfg),
        cfg.ode_t0,
        cfg.ode_t1,
        [0.5],
        cfg.ode_dt,
        cfg.ode_method,
    )
    print("Differential equation (logistic growth) sample:")
    print("  t       y")
    print(f"{t_values[0]:6.2f}  {y_values[0][0]:10.5f}")
    print(f"{t_values[-1]:6.2f}  {y_values[-1][0]:10.5f}")


def run_matrix_operations_example() -> None:
    a = [
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
        [7.0, 8.0, 9.0],
    ]
    b = [
        [9.0, 8.0, 7.0],
        [6.0, 5.0, 4.0],
        [3.0, 2.0, 1.0],
    ]
    c = matmul(a, b)
    print_matrix(c, "Result of matrix multiplication:")
    at = transpose(a)
    print_matrix(at, "Transpose of A:")
    print(f"Trace of A: {trace(a):10.4f}")
    print(f"Frobenius norm of A: {frobenius_norm(a):10.4f}")


def main(argv: list[str]) -> int:
    if len(argv) > 1:
        cfg = load_config(argv[1])
        print(f"Loaded configuration from {argv[1]}")
    else:
        cfg = SolverConfig()
        print("Using built-in default configuration")

    run_linear_system_example(cfg)
    run_differential_equation_example(cfg)
    run_matrix_operations_example()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
