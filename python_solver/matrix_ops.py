from __future__ import annotations

from typing import List

from math import sqrt


def matmul(a: List[List[float]], b: List[List[float]]) -> List[List[float]]:
    rows = len(a)
    cols = len(b[0])
    inner = len(b)
    result = [[0.0 for _ in range(cols)] for _ in range(rows)]
    for i in range(rows):
        for j in range(cols):
            result[i][j] = sum(a[i][k] * b[k][j] for k in range(inner))
    return result


def transpose(a: List[List[float]]) -> List[List[float]]:
    return [list(row) for row in zip(*a)]


def trace(a: List[List[float]]) -> float:
    return sum(a[i][i] for i in range(len(a)))


def frobenius_norm(a: List[List[float]]) -> float:
    return sqrt(sum(value * value for row in a for value in row))
