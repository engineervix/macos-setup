#!/usr/bin/env bash

# =================================================================================================
# description:  macOS Developer Setup
# author:       Victor Miti <https://github.com/engineervix>
# version:      1.0.0
# license:      MIT
#
# Usage: chmod +x install.sh && ./install.sh
# =================================================================================================

set -eo pipefail

# -----------------------------------------------------------------------------
# Color & Logging
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

export RED GREEN YELLOW CYAN NC

log()   { echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"; }
warn()  { echo -e "${YELLOW}[WARNING] $1${NC}"; }
error() { echo -e "${RED}[ERROR] $1${NC}"; exit 1; }
info()  { echo -e "${CYAN}[INFO] $1${NC}"; }

export -f log warn error info

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

log "Starting macOS Developer Setup..."

if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is for macOS only."
fi

source "${SCRIPT_DIR}/scripts/01_preflight.sh"
source "${SCRIPT_DIR}/scripts/02_homebrew.sh"
source "${SCRIPT_DIR}/scripts/03_tooling.sh"
source "${SCRIPT_DIR}/scripts/04_dotfiles.sh"

log "==========================================================="
log "Setup complete!"
log "==========================================================="
echo
info "Automated steps done:"
info "  1. macOS system defaults applied"
info "  2. Homebrew installed and Brewfile packages installed"
info "  3. Volta, Node, npm packages, Rustup, Claude Code, pipx packages set up"
info "  4. Neovim config cloned"
info "  5. git configured with delta"
info "  6. zshrc, aerospace.toml, SketchyBar and Karabiner-Elements configs symlinked"
info "  7. SketchyBar service started"
echo
warn "Manual steps still required (see mac-migration-plan.md):"
warn "  - Karabiner-Elements: grant permissions (System Extension, Accessibility, Login Items)"
warn "  - Maccy: set hotkey (suggested: cmd+shift+v) and configure history size"
warn "  - Kitty: copy ~/.config/kitty from Linux dotfiles"
warn "  - VS Code: sign in to Settings Sync"
warn "  - pyenv: install your Python version (pyenv install <version>)"
warn "  - Manual installs: Office 365, Ableton, Vital, Splice, BricsCAD, NTFS for Mac"
echo
warn "Open a new terminal session to load the new shell config."
