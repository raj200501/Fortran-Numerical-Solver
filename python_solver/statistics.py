from __future__ import annotations

from math import sqrt
from typing import List


def mean_vector(x: List[float]) -> float:
    return sum(x) / len(x)


def variance_vector(x: List[float], sample: bool = False) -> float:
    mu = mean_vector(x)
    denom = len(x) - 1 if sample else len(x)
    return sum((val - mu) ** 2 for val in x) / denom


def stddev_vector(x: List[float], sample: bool = False) -> float:
    return sqrt(variance_vector(x, sample=sample))


def covariance_matrix(data: List[List[float]]) -> List[List[float]]:
    n_samples = len(data)
    n_features = len(data[0])
    means = [mean_vector([row[j] for row in data]) for j in range(n_features)]
    centered = [[row[j] - means[j] for j in range(n_features)] for row in data]
    cov = [[0.0 for _ in range(n_features)] for _ in range(n_features)]
    for i in range(n_features):
        for j in range(n_features):
            cov[i][j] = sum(centered[k][i] * centered[k][j] for k in range(n_samples)) / (n_samples - 1)
    return cov
