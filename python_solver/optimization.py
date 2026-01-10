from __future__ import annotations

from typing import Callable, Tuple


def gradient_descent(
    f: Callable[[float], float],
    g: Callable[[float], float],
    x0: float,
    alpha: float,
    tol: float,
    max_iter: int,
) -> Tuple[float, int, bool]:
    x = x0
    for iteration in range(1, max_iter + 1):
        grad = g(x)
        step = alpha * grad
        x -= step
        if abs(step) < tol or abs(grad) < tol:
            return x, iteration, True
    return x, max_iter, False


def momentum_descent(
    f: Callable[[float], float],
    g: Callable[[float], float],
    x0: float,
    alpha: float,
    beta: float,
    tol: float,
    max_iter: int,
) -> Tuple[float, int, bool]:
    x = x0
    v = 0.0
    for iteration in range(1, max_iter + 1):
        grad = g(x)
        v = beta * v + alpha * grad
        x -= v
        if abs(v) < tol or abs(grad) < tol:
            return x, iteration, True
    return x, max_iter, False


def backtracking_line_search(
    f: Callable[[float], float],
    g: Callable[[float], float],
    x: float,
    direction: float,
    alpha0: float,
    rho: float,
    c: float,
) -> float:
    alpha = alpha0
    fx = f(x)
    gdir = g(x) * direction
    while f(x + alpha * direction) > fx + c * alpha * gdir:
        alpha *= rho
        if alpha < 1.0e-12:
            break
    return alpha
