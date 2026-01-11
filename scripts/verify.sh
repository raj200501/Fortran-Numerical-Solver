#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

BOOTSTRAP_OUTPUT=$("${ROOT_DIR}/scripts/bootstrap_fortran.sh")
FC=$(echo "${BOOTSTRAP_OUTPUT}" | awk -F= '/^FC=/{print $2}')
FFLAGS=$(echo "${BOOTSTRAP_OUTPUT}" | sed -n 's/^FFLAGS=//p')

if [[ -n "${FC}" ]]; then
  make -C "${ROOT_DIR}" clean
  make -C "${ROOT_DIR}" FC="${FC}" FFLAGS="${FFLAGS}"
  make -C "${ROOT_DIR}" test FC="${FC}" FFLAGS="${FFLAGS}"
fi

python -m unittest discover -s "${ROOT_DIR}/python_tests"

OUTPUT_FILE=$(mktemp)
trap 'rm -f "${OUTPUT_FILE}"' EXIT

if [[ -n "${FC}" ]]; then
  "${ROOT_DIR}/build/bin/solver" "${ROOT_DIR}/examples/default_config.cfg" | tee "${OUTPUT_FILE}"
else
  python -m python_solver.solver "${ROOT_DIR}/examples/default_config.cfg" | tee "${OUTPUT_FILE}"
fi

# Smoke checks for key output sections
required_strings=(
  "Solution of the linear system (LU):"
  "Jacobi converged:"
  "Gauss-Seidel converged:"
  "Conjugate Gradient converged:"
  "Differential equation (logistic growth) sample:"
  "Result of matrix multiplication:"
  "Trace of A:"
  "Frobenius norm of A:"
)

for str in "${required_strings[@]}"; do
  if ! grep -q "$str" "${OUTPUT_FILE}"; then
    echo "Missing expected output: $str" >&2
    exit 1
  fi
done

# Numeric smoke check: final logistic value should be between 0 and K
final_y=$(awk 'NF==2 && $1 ~ /^[0-9]/ {val=$2} END {print val}' "${OUTPUT_FILE}")
if [[ -z "${final_y}" ]]; then
  echo "Failed to parse final logistic value" >&2
  exit 1
fi
awk -v y="$final_y" 'BEGIN { if (y <= 0 || y >= 10.0) exit 1; }'

printf "Verification successful.\n"
