# Configuration Reference

This document describes the configuration system used by the solver demo.
The configuration format is a simple `key=value` text file with optional
comments. Each line is parsed independently.

## Format Rules

- Blank lines are ignored.
- Lines beginning with `#` are treated as comments.
- Keys are case-sensitive.
- Whitespace around the key and value is ignored.
- Unknown keys are ignored to allow forward compatibility.

## Supported Keys

### `linear_size`

Integer size of the linear system example. The demo currently expects `3`
because the built-in matrix is `3x3`. Future versions could make this dynamic.

### `ode_t0`

The initial time `t0` for the differential equation solver.

### `ode_t1`

The final time `t1` for the differential equation solver. Must be greater than
`t0`.

### `ode_dt`

Time step size. Must be positive. Smaller values increase accuracy but increase
runtime.

### `ode_r`

Growth rate parameter for the logistic growth ODE.

### `ode_k`

Carrying capacity for the logistic growth ODE.

### `ode_method`

ODE integration method. Valid values:

- `euler`
- `rk4`

## Example Configuration

```
# Example settings
linear_size=3
ode_t0=0.0
ode_t1=2.0
ode_dt=0.1
ode_r=1.5
ode_k=10.0
ode_method=rk4
```

## Error Handling

The configuration loader fails fast if the file cannot be opened. It does not
validate values beyond numeric parsing, so invalid numeric values (e.g.,
`ode_dt=foo`) will cause a read error at runtime. To troubleshoot, simplify the
file and reintroduce values one by one.

## Extending the Configuration

To add a new configuration key:

1. Update `type(solver_config)` in `src/config.f90`.
2. Add a case in `parse_entry` that parses the new key.
3. Update the README and this document.
4. Add a test case in `tests/test_config.f90`.

