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
# JankyBorders — config symlink + service start
# -----------------------------------------------------------------------------
log "Symlinking JankyBorders config..."
mkdir -p "$HOME/.config/borders"
link "${SCRIPT_DIR}/conf/borders/bordersrc" "$HOME/.config/borders/bordersrc"

log "Starting JankyBorders service..."
if brew list borders &>/dev/null; then
    brew services start borders 2>/dev/null || true
    info "JankyBorders started."
else
    warn "JankyBorders not installed — skipping service start."
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
# Vim configuration
# -----------------------------------------------------------------------------
log "Configuring Vim..."
wget https://raw.githubusercontent.com/engineervix/opensuse-setup/0123da14/conf/vimrc -O "$HOME/.vimrc"

# Install vim-plug
log "Installing vim-plug plugin manager..."
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    log "vim-plug installed successfully"
else
    info "vim-plug already installed, skipping..."
fi

# Install vim plugins
log "Installing vim plugins (this may take a few minutes)..."
info "Note: YouCompleteMe will compile in the background - this is normal and may take some time"

# Install plugins in a more controlled way
if vim --not-a-term -c 'PlugInstall --sync | qa!' > /tmp/vim-plug-install.log 2>&1; then
    log "Vim plugins installed successfully"

    # Check if YouCompleteMe needs manual compilation (fallback)
    if [ -d "$HOME/.vim/plugged/YouCompleteMe" ] && [ ! -f "$HOME/.vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
        log "Compiling YouCompleteMe manually..."
        (
            cd "$HOME/.vim/plugged/YouCompleteMe" || exit
            if python3 install.py > /tmp/ycm-install.log 2>&1; then
                log "YouCompleteMe compiled successfully"
            else
                warn "YouCompleteMe compilation had issues - check /tmp/ycm-install.log"
                warn "You may need to install additional development packages"
            fi
        )
    fi

    # Install Go binaries for vim-go
    if [ -d "$HOME/.vim/plugged/vim-go" ]; then
        log "Installing vim-go binaries..."
        vim --not-a-term -c 'GoUpdateBinaries | qa!' > /tmp/vim-go-install.log 2>&1 || \
            warn "vim-go binaries may need manual install - run ':GoUpdateBinaries' in vim"
    fi
else
    warn "Some vim plugins may not have installed correctly - check /tmp/vim-plug-install.log"
    warn "You can manually run ':PlugInstall' in vim to retry"
fi

log "Vim setup completed! Use ':NERDTree' to open file explorer, ':Files' for fuzzy finding."

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
