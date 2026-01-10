from __future__ import annotations

from math import sqrt
from typing import List


def moving_average(x: List[float], window: int) -> List[float]:
    if window < 1 or window > len(x):
        raise ValueError("invalid window")
    result = []
    for i in range(len(x)):
        start = max(0, i - window + 1)
        segment = x[start : i + 1]
        result.append(sum(segment) / len(segment))
    return result


def exponential_smoothing(x: List[float], alpha: float) -> List[float]:
    if alpha <= 0 or alpha > 1:
        raise ValueError("alpha must be in (0,1]")
    result = [x[0]]
    for i in range(1, len(x)):
        result.append(alpha * x[i] + (1 - alpha) * result[i - 1])
    return result


def mean_absolute_error(actual: List[float], predicted: List[float]) -> float:
    return sum(abs(a - p) for a, p in zip(actual, predicted)) / len(actual)


def mean_squared_error(actual: List[float], predicted: List[float]) -> float:
    return sum((a - p) ** 2 for a, p in zip(actual, predicted)) / len(actual)


def root_mean_squared_error(actual: List[float], predicted: List[float]) -> float:
    return sqrt(mean_squared_error(actual, predicted))
