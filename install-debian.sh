#!/usr/bin/env bash
# Debian/Ubuntu packages for mps-terminal-fonts (best-effort).
# Toggle (default matches the odem.terminal.fonts role): MPS_FONTS_ENABLE_DEPS
set -euo pipefail

SUDO=""
[[ ${EUID} -eq 0 ]] || SUDO="sudo"

ENABLE_DEPS="${MPS_FONTS_ENABLE_DEPS:-1}"

if [[ "${ENABLE_DEPS}" = 1 ]]; then
    ${SUDO} apt-get install -y fontconfig unzip
fi

echo "mps-terminal-fonts Debian packages ready."
