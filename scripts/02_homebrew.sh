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

log "Adding third-party taps..."
brew tap FelixKratz/formulae
brew tap nikitabobko/tap
brew tap mediosz/tap
brew tap hashicorp/tap
brew tap chrismytton/formula

log "Trusting third-party formulae and casks..."
brew trust --formula \
    chrismytton/formula/shoreman \
    hashicorp/tap/terraform \
    felixkratz/formulae/sketchybar \
    felixkratz/formulae/borders
brew trust --cask \
    nikitabobko/tap/aerospace \
    mediosz/tap/swipeaerospace

log "Running Brewfile..."
HOMEBREW_BUNDLE_NO_LOCK=1 brew bundle --file="${SCRIPT_DIR}/Brewfile" -v

log "Homebrew setup complete."
