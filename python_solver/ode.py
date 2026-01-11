from __future__ import annotations

from typing import Callable, List, Tuple


def euler_step(f: Callable[[float, List[float]], List[float]], t: float, y: List[float], dt: float) -> List[float]:
    dydt = f(t, y)
    return [y_i + dt * dy_i for y_i, dy_i in zip(y, dydt)]


def rk4_step(f: Callable[[float, List[float]], List[float]], t: float, y: List[float], dt: float) -> List[float]:
    k1 = f(t, y)
    y2 = [y_i + 0.5 * dt * k1_i for y_i, k1_i in zip(y, k1)]
    k2 = f(t + 0.5 * dt, y2)
    y3 = [y_i + 0.5 * dt * k2_i for y_i, k2_i in zip(y, k2)]
    k3 = f(t + 0.5 * dt, y3)
    y4 = [y_i + dt * k3_i for y_i, k3_i in zip(y, k3)]
    k4 = f(t + dt, y4)
    return [
        y_i + (dt / 6.0) * (k1_i + 2 * k2_i + 2 * k3_i + k4_i)
        for y_i, k1_i, k2_i, k3_i, k4_i in zip(y, k1, k2, k3, k4)
    ]


def solve_ivp(
    f: Callable[[float, List[float]], List[float]],
    t0: float,
    t1: float,
    y0: List[float],
    dt: float,
    method: str,
) -> Tuple[List[float], List[List[float]]]:
    steps = int((t1 - t0) / dt) + 1
    t_values = [t0 + i * dt for i in range(steps)]
    y_values = [y0]
    y = y0
    for i in range(1, steps):
        if method == "euler":
            y = euler_step(f, t_values[i - 1], y, dt)
        elif method == "rk4":
            y = rk4_step(f, t_values[i - 1], y, dt)
        else:
            raise ValueError("Unknown method")
        y_values.append(y)
    return t_values, y_values
