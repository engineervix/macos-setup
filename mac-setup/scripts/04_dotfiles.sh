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
    local backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
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
# Starship — symlink from dotfiles repo if available, else note manual step
# -----------------------------------------------------------------------------
DOTFILES_STARSHIP="$HOME/dotfiles/.config/starship.toml"
if [ -f "$DOTFILES_STARSHIP" ]; then
    mkdir -p "$HOME/.config"
    link "$DOTFILES_STARSHIP" "$HOME/.config/starship.toml"
    info "Starship config linked from dotfiles repo."
else
    warn "starship.toml not found at ${DOTFILES_STARSHIP}"
    warn "Copy it manually: cp ~/dotfiles/.config/starship.toml ~/.config/starship.toml"
fi

# -----------------------------------------------------------------------------
# Kitty — symlink from dotfiles repo if available
# -----------------------------------------------------------------------------
DOTFILES_KITTY="$HOME/dotfiles/.config/kitty"
if [ -d "$DOTFILES_KITTY" ]; then
    mkdir -p "$HOME/.config"
    link "$DOTFILES_KITTY" "$HOME/.config/kitty"
    info "Kitty config linked from dotfiles repo."
    warn "If fonts don't render correctly in Kitty, change kitty.conf:"
    warn "  font_family JetBrainsMonoNL NFM"
else
    warn "Kitty config not found at ${DOTFILES_KITTY}"
    warn "Copy it manually: cp -r ~/dotfiles/.config/kitty ~/.config/kitty"
fi

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
