from __future__ import annotations

from typing import List


def linear_interpolate(x0: float, y0: float, x1: float, y1: float, x: float) -> float:
    if x1 == x0:
        raise ValueError("x0 and x1 must differ")
    return y0 + (y1 - y0) * (x - x0) / (x1 - x0)


def lagrange_interpolate(x_data: List[float], y_data: List[float], x: float) -> float:
    n = len(x_data)
    if n != len(y_data):
        raise ValueError("size mismatch")
    total = 0.0
    for i in range(n):
        term = y_data[i]
        for j in range(n):
            if i != j:
                if x_data[i] == x_data[j]:
                    raise ValueError("duplicate x values")
                term *= (x - x_data[j]) / (x_data[i] - x_data[j])
        total += term
    return total


def linspace(a: float, b: float, n: int) -> List[float]:
    if n < 2:
        raise ValueError("n must be >= 2")
    return [a + (b - a) * i / (n - 1) for i in range(n)]
