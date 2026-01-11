from __future__ import annotations

from typing import Callable, Tuple


def bisection(
    f: Callable[[float], float],
    a: float,
    b: float,
    tol: float,
    max_iter: int,
) -> Tuple[float, int, bool]:
    fa = f(a)
    fb = f(b)
    if fa * fb > 0:
        raise ValueError("Root not bracketed")
    left, right = a, b
    for iteration in range(1, max_iter + 1):
        mid = 0.5 * (left + right)
        fmid = f(mid)
        if abs(fmid) <= tol or abs(right - left) <= tol:
            return mid, iteration, True
        if fa * fmid < 0:
            right = mid
            fb = fmid
        else:
            left = mid
            fa = fmid
    return mid, max_iter, False


def newton(
    f: Callable[[float], float],
    df: Callable[[float], float],
    x0: float,
    tol: float,
    max_iter: int,
) -> Tuple[float, int, bool]:
    x = x0
    for iteration in range(1, max_iter + 1):
        fx = f(x)
        dfx = df(x)
        if dfx == 0:
            raise ValueError("Derivative zero")
        step = fx / dfx
        x -= step
        if abs(step) < tol or abs(fx) < tol:
            return x, iteration, True
    return x, max_iter, False


def secant(
    f: Callable[[float], float],
    x0: float,
    x1: float,
    tol: float,
    max_iter: int,
) -> Tuple[float, int, bool]:
    x_prev, x_curr = x0, x1
    for iteration in range(1, max_iter + 1):
        f_prev = f(x_prev)
        f_curr = f(x_curr)
        denom = f_curr - f_prev
        if denom == 0:
            raise ValueError("Zero denominator")
        x_next = x_curr - f_curr * (x_curr - x_prev) / denom
        if abs(x_next - x_curr) < tol or abs(f_curr) < tol:
            return x_next, iteration, True
        x_prev, x_curr = x_curr, x_next
    return x_curr, max_iter, False
