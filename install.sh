#!/usr/bin/env bash
# Install mps-terminal-fonts system-wide: Nerd Fonts (JetBrainsMono) and the
# codicon icon font into /usr/share/fonts. Idempotent.
# OS-specific packages live in install-debian.sh / install-fedora.sh and are
# installed best-effort before the fonts deploy.
# Toggles (defaults match the odem.terminal.fonts role):
#   MPS_FONTS_ENABLE_INSTALL / MPS_FONTS_ENABLE_DEPS (read by the OS scripts)
#   MPS_FONTS_DIR overrides /usr/share/fonts (e.g. for testing)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FONTS_DIR="${MPS_FONTS_DIR:-/usr/share/fonts}"
ENABLE_INSTALL="${MPS_FONTS_ENABLE_INSTALL:-1}"

SUDO=""
[[ ${EUID} -eq 0 ]] || SUDO="sudo"

#--- Distro detection -----------------------------------------------------------
detect_distro() {
    local id
    id="$(grep -sE '^ID=' /etc/os-release | head -1 | cut -d= -f2 | tr -d '\"')"
    case "${id}" in
        debian|ubuntu) echo "debian" ;;
        fedora|rhel)   echo "fedora" ;;
        *)
            if command -v apt-get >/dev/null 2>&1; then echo "debian"
            elif command -v dnf >/dev/null 2>&1; then echo "fedora"
            else echo "none"; fi ;;
    esac
}

#--- System: distro packages (best-effort; DEPS toggle read by the OS script) ---
case "$(detect_distro)" in
    debian) "${SRC}/install-debian.sh" || echo "==> WARN: install-debian.sh failed; continuing" ;;
    fedora)  "${SRC}/install-fedora.sh" || echo "==> WARN: install-fedora.sh failed; continuing" ;;
    *)       echo "==> Unsupported distro — skipping system packages" ;;
esac

#--- System: fonts ----------------------------------------------------------------
if [[ "${ENABLE_INSTALL}" = 1 ]]; then
    # JetBrainsMono Nerd Font
    ${SUDO} install -d -m 0755 "${FONTS_DIR}/JetBrainsMono"
    if [[ ! -f "${FONTS_DIR}/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf" ]]; then
        tmp="$(mktemp -d)"
        curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip -o "${tmp}/JetBrainsMono.zip"
        ${SUDO} unzip -q "${tmp}/JetBrainsMono.zip" -d "${FONTS_DIR}/JetBrainsMono"
        rm -rf "${tmp}"
    fi

    # codicon icon font
    if [[ ! -f "${FONTS_DIR}/codicon/codicon.ttf" ]]; then
        ${SUDO} install -d -m 0755 "${FONTS_DIR}/codicon"
        ${SUDO} curl -fsSL https://github.com/microsoft/vscode-codicons/releases/download/0.0.36/codicon.ttf -o "${FONTS_DIR}/codicon/codicon.ttf"
        ${SUDO} chmod 0644 "${FONTS_DIR}/codicon/codicon.ttf"
    fi

    # Rebuild the font cache (mirrors the odem.terminal.fonts role handler).
    ${SUDO} fc-cache -f
fi

echo "mps-terminal-fonts installed to ${FONTS_DIR}."
