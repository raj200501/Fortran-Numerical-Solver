from __future__ import annotations

from dataclasses import dataclass


@dataclass
class SolverConfig:
    linear_size: int = 3
    ode_t0: float = 0.0
    ode_t1: float = 2.0
    ode_dt: float = 0.1
    ode_r: float = 1.5
    ode_k: float = 10.0
    ode_method: str = "rk4"


def load_config(path: str) -> SolverConfig:
    cfg = SolverConfig()
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            line = raw_line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" not in line:
                continue
            key, value = (item.strip() for item in line.split("=", 1))
            if key == "linear_size":
                cfg.linear_size = int(value)
            elif key == "ode_t0":
                cfg.ode_t0 = float(value)
            elif key == "ode_t1":
                cfg.ode_t1 = float(value)
            elif key == "ode_dt":
                cfg.ode_dt = float(value)
            elif key == "ode_r":
                cfg.ode_r = float(value)
            elif key == "ode_k":
                cfg.ode_k = float(value)
            elif key == "ode_method":
                cfg.ode_method = value
    return cfg
