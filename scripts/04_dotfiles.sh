#!/usr/bin/env bash
# =============================================================================
# Script: 04_dotfiles.sh
# Description: Writes config files and creates symlinks.
# =============================================================================

log "--- [Phase 4: Dotfiles & Config] ---"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
backup_and_remove() {
    local target="$1"
    local backup
    backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    warn "Backing up '${target}' → '${backup}'"
    mv "$target" "$backup"
}

link() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        warn "Source '${src}' does not exist — skipping."
        return
    fi

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        info "Already linked: ${dest}"
        return
    fi

    if [ -L "$dest" ]; then
        warn "Removing stale symlink: ${dest}"
        rm "$dest"
    fi

    if [ -e "$dest" ]; then
        backup_and_remove "$dest"
    fi

    ln -s "$src" "$dest"
    log "Linked: ${dest} -> ${src}"
}

# -----------------------------------------------------------------------------
# ~/.zshrc
# -----------------------------------------------------------------------------
log "Symlinking .zshrc..."
link "${SCRIPT_DIR}/conf/zshrc" "$HOME/.zshrc"

# -----------------------------------------------------------------------------
# Aerospace
# -----------------------------------------------------------------------------
log "Symlinking Aerospace config..."
link "${SCRIPT_DIR}/conf/aerospace.toml" "$HOME/.aerospace.toml"

# -----------------------------------------------------------------------------
# Karabiner-Elements
# Symlink the whole directory — karabiner.json must not itself be a symlink
# or Karabiner-Elements won't detect changes and auto-reload.
# -----------------------------------------------------------------------------
log "Symlinking Karabiner-Elements config..."
mkdir -p "$HOME/.config"
link "${SCRIPT_DIR}/conf/karabiner" "$HOME/.config/karabiner"

# -----------------------------------------------------------------------------
# Dotfiles repo — clone if not already present
# -----------------------------------------------------------------------------
DOTFILES_DIR="$HOME/dotfiles"
log "Ensuring dotfiles repo is available..."
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    git clone https://github.com/engineervix/dotfiles.git "$DOTFILES_DIR"
    info "Cloned dotfiles repo to ${DOTFILES_DIR}."
else
    info "Dotfiles repo already present at ${DOTFILES_DIR}."
fi

# -----------------------------------------------------------------------------
# Starship
# -----------------------------------------------------------------------------
mkdir -p "$HOME/.config"
link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# -----------------------------------------------------------------------------
# Kitty
# -----------------------------------------------------------------------------
link "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"
warn "If fonts don't render correctly in Kitty, change kitty.conf:"
warn "  font_family JetBrainsMonoNL NFM"

# -----------------------------------------------------------------------------
# SketchyBar — config symlink + service start
# -----------------------------------------------------------------------------
log "Symlinking SketchyBar config..."
mkdir -p "$HOME/.config"
link "${SCRIPT_DIR}/conf/sketchybar" "$HOME/.config/sketchybar"

# Ensure plugins are executable after symlinking
chmod +x "$HOME/.config/sketchybar/plugins/"*.sh 2>/dev/null || true

log "Starting SketchyBar service..."
if brew list sketchybar &>/dev/null; then
    brew services start sketchybar 2>/dev/null || true
    info "SketchyBar started with Catppuccin Mocha config."
else
    warn "SketchyBar not installed — skipping service start."
fi

# -----------------------------------------------------------------------------
# Set zsh as the default shell (it already is on macOS 10.15+, but be sure)
# -----------------------------------------------------------------------------
ZSH_PATH="$(brew --prefix)/bin/zsh"
if [ -f "$ZSH_PATH" ]; then
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        log "Adding Homebrew zsh to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    if [ "$SHELL" != "$ZSH_PATH" ]; then
        log "Setting Homebrew zsh as default shell..."
        chsh -s "$ZSH_PATH"
    else
        info "Default shell is already Homebrew zsh."
    fi
fi

log "Dotfiles setup complete."
