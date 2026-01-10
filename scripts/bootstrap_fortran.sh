#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TOOL_DIR="${ROOT_DIR}/.tooling"
LFORTRAN_VERSION="0.35.0"
LFORTRAN_DIR="${TOOL_DIR}/lfortran-${LFORTRAN_VERSION}"
LFORTRAN_TARBALL="${TOOL_DIR}/lfortran-${LFORTRAN_VERSION}.tar.gz"

if command -v gfortran >/dev/null 2>&1; then
  echo "gfortran found: $(command -v gfortran)"
  echo "FC=gfortran"
  echo "FFLAGS=-O2 -Wall -Wextra -fcheck=all -Jbuild/obj -Ibuild/obj"
  exit 0
fi

mkdir -p "${TOOL_DIR}"
if [[ ! -d "${LFORTRAN_DIR}" ]]; then
  echo "gfortran not found. Attempting to download LFortran ${LFORTRAN_VERSION}..."
  if ! curl -L "https://github.com/lfortran/lfortran/releases/download/v${LFORTRAN_VERSION}/lfortran-${LFORTRAN_VERSION}-linux-x86_64.tar.gz" -o "${LFORTRAN_TARBALL}"; then
    echo "Failed to download LFortran. Proceeding without a Fortran compiler." >&2
    echo "FC="
    echo "FFLAGS="
    exit 0
  fi
  mkdir -p "${LFORTRAN_DIR}"
  tar -xzf "${LFORTRAN_TARBALL}" -C "${LFORTRAN_DIR}" --strip-components=1
fi

if [[ ! -x "${LFORTRAN_DIR}/bin/lfortran" ]]; then
  echo "Failed to install LFortran. Proceeding without a Fortran compiler." >&2
  echo "FC="
  echo "FFLAGS="
  exit 0
fi

echo "Using LFortran: ${LFORTRAN_DIR}/bin/lfortran"
# LFortran does not support -fcheck=all, so use compatible flags.
echo "FC=${LFORTRAN_DIR}/bin/lfortran"
# Use -std=f2008 for compatibility if supported; ignore if not.
echo "FFLAGS=-O2 -Wall -Wextra -Jbuild/obj -Ibuild/obj"
