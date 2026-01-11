from __future__ import annotations

from math import sqrt
from typing import Iterable, List


def print_vector(vector: Iterable[float], title: str | None = None) -> None:
    if title:
        print(title)
    for i, value in enumerate(vector, start=1):
        print(f"  [{i}] = {value:0.4f}")


def print_matrix(matrix: Iterable[Iterable[float]], title: str | None = None) -> None:
    if title:
        print(title)
    for row in matrix:
        formatted = " ".join(f"{value:10.4f}" for value in row)
        print(formatted)


def norm2(vector: Iterable[float]) -> float:
    return sqrt(sum(v * v for v in vector))


def dot(a: Iterable[float], b: Iterable[float]) -> float:
    return sum(x * y for x, y in zip(a, b))


def max_abs_diff(a: Iterable[float], b: Iterable[float]) -> float:
    return max(abs(x - y) for x, y in zip(a, b))


def max_abs_diff_matrix(a: List[List[float]], b: List[List[float]]) -> float:
    max_val = 0.0
    for row_a, row_b in zip(a, b):
        max_val = max(max_val, max(abs(x - y) for x, y in zip(row_a, row_b)))
    return max_val
