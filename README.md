# mps-terminal-fonts

System-wide fonts of the my-perfect-system (mps) terminal stack — Nerd Fonts (JetBrainsMono) and icon fonts (codicon) installed to `/usr/share/fonts`.

## Install

| Method | Description |
| --- | --- |
| Default | `bootstrap.sh` clones to the system-wide mps repo dir and runs `install.sh` (sudo) |
| Ansible | can be used by installing via the `odem.terminal.fonts` role of [odem-terminal](https://github.com/my-perfect-system/odem-terminal) |
| Standalone | clone the repo, then run `sudo ./install.sh` inside it |

### Install (Default)

```bash
curl -fsSL https://raw.githubusercontent.com/my-perfect-system/mps-terminal-fonts/main/bootstrap.sh | bash
```

Font downloads install to `${MPS_FONTS_DIR:-/usr/share/fonts}` — one copy per host, shared by all users; re-run to update. `fc-cache` rebuilds the font cache.

## Usage

```bash
fc-list | grep -i jetbrains      # list installed JetBrainsMono faces
fc-cache -f                     # rebuild the font cache after changes
```
