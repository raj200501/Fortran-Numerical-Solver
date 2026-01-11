from __future__ import annotations

from typing import List, Tuple

from python_solver.utils import dot, norm2


def lu_factor(a: List[List[float]]) -> Tuple[List[List[float]], List[List[float]], List[int], int]:
    n = len(a)
    l = [[0.0 for _ in range(n)] for _ in range(n)]
    u = [row[:] for row in a]
    piv = list(range(n))
    info = 0

    for k in range(n):
        pivot_row = max(range(k, n), key=lambda i: abs(u[i][k]))
        if u[pivot_row][k] == 0.0:
            info = k + 1
            break
        if pivot_row != k:
            u[k], u[pivot_row] = u[pivot_row], u[k]
            l[k], l[pivot_row] = l[pivot_row], l[k]
            piv[k], piv[pivot_row] = piv[pivot_row], piv[k]
        l[k][k] = 1.0
        for i in range(k + 1, n):
            l[i][k] = u[i][k] / u[k][k]
            for j in range(k, n):
                u[i][j] -= l[i][k] * u[k][j]
    return l, u, piv, info


def forward_substitution(l: List[List[float]], b: List[float]) -> List[float]:
    n = len(l)
    y = [0.0 for _ in range(n)]
    for i in range(n):
        y[i] = b[i] - sum(l[i][j] * y[j] for j in range(i))
        y[i] /= l[i][i]
    return y


def backward_substitution(u: List[List[float]], y: List[float]) -> List[float]:
    n = len(u)
    x = [0.0 for _ in range(n)]
    for i in range(n - 1, -1, -1):
        x[i] = y[i] - sum(u[i][j] * x[j] for j in range(i + 1, n))
        x[i] /= u[i][i]
    return x


def solve_linear_system(a: List[List[float]], b: List[float]) -> Tuple[List[float], int]:
    l, u, piv, info = lu_factor(a)
    if info != 0:
        return [0.0 for _ in b], info
    bp = [b[piv[i]] for i in range(len(b))]
    y = forward_substitution(l, bp)
    x = backward_substitution(u, y)
    return x, 0


def jacobi(a: List[List[float]], b: List[float], max_iter: int, tol: float) -> Tuple[List[float], int, bool]:
    n = len(a)
    x = [0.0 for _ in range(n)]
    for iteration in range(1, max_iter + 1):
        x_new = [0.0 for _ in range(n)]
        for i in range(n):
            sigma = sum(a[i][j] * x[j] for j in range(n) if j != i)
            x_new[i] = (b[i] - sigma) / a[i][i]
        diff = norm2([x_new[i] - x[i] for i in range(n)])
        x = x_new
        if diff < tol:
            return x, iteration, True
    return x, max_iter, False


def gauss_seidel(a: List[List[float]], b: List[float], max_iter: int, tol: float) -> Tuple[List[float], int, bool]:
    n = len(a)
    x = [0.0 for _ in range(n)]
    for iteration in range(1, max_iter + 1):
        x_old = x[:]
        for i in range(n):
            sigma = sum(a[i][j] * x[j] for j in range(n) if j != i)
            x[i] = (b[i] - sigma) / a[i][i]
        diff = norm2([x[i] - x_old[i] for i in range(n)])
        if diff < tol:
            return x, iteration, True
    return x, max_iter, False


def conjugate_gradient(a: List[List[float]], b: List[float], max_iter: int, tol: float) -> Tuple[List[float], int, bool]:
    n = len(a)
    x = [0.0 for _ in range(n)]
    r = [b[i] - dot(a[i], x) for i in range(n)]
    p = r[:]
    rs_old = dot(r, r)
    for iteration in range(1, max_iter + 1):
        ap = [dot(a[i], p) for i in range(n)]
        alpha = rs_old / dot(p, ap)
        x = [x[i] + alpha * p[i] for i in range(n)]
        r = [r[i] - alpha * ap[i] for i in range(n)]
        rs_new = dot(r, r)
        if rs_new ** 0.5 < tol:
            return x, iteration, True
        beta = rs_new / rs_old
        p = [r[i] + beta * p[i] for i in range(n)]
        rs_old = rs_new
    return x, max_iter, False
