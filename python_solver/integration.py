from __future__ import annotations

from typing import Callable, Tuple


def trapezoidal(f: Callable[[float], float], a: float, b: float, n: int) -> float:
    h = (b - a) / n
    area = 0.5 * (f(a) + f(b))
    for i in range(1, n):
        area += f(a + h * i)
    return area * h


def simpson(f: Callable[[float], float], a: float, b: float, n: int) -> float:
    if n % 2 != 0:
        raise ValueError("n must be even")
    h = (b - a) / n
    area = f(a) + f(b)
    for i in range(1, n):
        coeff = 4.0 if i % 2 == 1 else 2.0
        area += coeff * f(a + h * i)
    return area * h / 3.0


def adaptive_trapezoidal(
    f: Callable[[float], float],
    a: float,
    b: float,
    tol: float,
    max_iter: int,
) -> Tuple[float, int, bool]:
    n = 1
    prev = trapezoidal(f, a, b, n)
    for iteration in range(1, max_iter + 1):
        n *= 2
        curr = trapezoidal(f, a, b, n)
        if abs(curr - prev) < tol:
            return curr, iteration, True
        prev = curr
    return curr, max_iter, False
