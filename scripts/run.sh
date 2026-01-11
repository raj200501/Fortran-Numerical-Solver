#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

BOOTSTRAP_OUTPUT=$("${ROOT_DIR}/scripts/bootstrap_fortran.sh")
FC=$(echo "${BOOTSTRAP_OUTPUT}" | awk -F= '/^FC=/{print $2}')
FFLAGS=$(echo "${BOOTSTRAP_OUTPUT}" | sed -n 's/^FFLAGS=//p')

CONFIG_FILE=${1:-}

if [[ -n "${FC}" ]]; then
  make -C "${ROOT_DIR}" clean
  make -C "${ROOT_DIR}" FC="${FC}" FFLAGS="${FFLAGS}"
  if [[ -n "${CONFIG_FILE}" ]]; then
    "${ROOT_DIR}/build/bin/solver" "${CONFIG_FILE}"
  else
    "${ROOT_DIR}/build/bin/solver"
  fi
else
  if [[ -n "${CONFIG_FILE}" ]]; then
    python -m python_solver.solver "${CONFIG_FILE}"
  else
    python -m python_solver.solver
  fi
fi
