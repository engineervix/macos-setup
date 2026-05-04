#!/usr/bin/env bash
# =============================================================================
# Script: 01_preflight.sh
# Description: Checks prerequisites and applies macOS system defaults.
# =============================================================================

log "--- [Phase 1: Preflight] ---"

# Xcode CLI tools
if ! xcode-select -p &>/dev/null; then
    log "Installing Xcode Command Line Tools..."
    xcode-select --install
    info "A dialog has appeared to install the Xcode CLI tools."
    info "Please complete that installation, then re-run this script."
    exit 0
else
    info "Xcode CLI tools already installed."
fi

# Create common directories
mkdir -p "$HOME/bin" "$HOME/.local/bin" "$HOME/.zsh/cache" "$HOME/.zfunc"

# =============================================================================
# macOS system defaults
# Applied once; harmless to re-run.
# =============================================================================
log "Applying macOS system defaults..."

# --- Dock ---
# Auto-hide the Dock with no delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
# Remove the default apps from the Dock (keep it clean — Aerospace manages workspaces)
defaults write com.apple.dock persistent-apps -array
# Don't show recent applications in the Dock
defaults write com.apple.dock show-recents -bool false

# --- Finder ---
# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# --- Animation & responsiveness ---
# Disable window open/close animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# Speed up Mission Control animation
defaults write com.apple.dock expose-animation-duration -float 0.1
# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# --- Keyboard ---
# Key repeat rate (faster)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable automatic capitalisation and smart dashes
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# --- Screenshots ---
# Save screenshots to ~/Pictures/Screenshots
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
# Save in PNG format
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# --- Trackpad ---
# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# --- Menu bar ---
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Apply Dock changes
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

log "macOS defaults applied."
