#!/usr/bin/env bash
# =============================================================================
# Script: 02_homebrew.sh
# Description: Installs Homebrew and runs the Brewfile.
# =============================================================================

log "--- [Phase 2: Homebrew & Packages] ---"

# Install Homebrew
if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH for the rest of this script session
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    info "Homebrew already installed."
    eval "$(brew shellenv)"
fi

log "Updating Homebrew..."
brew update

log "Running Brewfile..."
brew bundle --file="${SCRIPT_DIR}/Brewfile" --no-lock

log "Homebrew setup complete."
