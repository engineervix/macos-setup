#!/usr/bin/env bash
# =============================================================================
# Script: 03_tooling.sh
# Description: Sets up language runtimes, global packages, and dev tooling.
# =============================================================================

log "--- [Phase 3: Development Tooling] ---"

# =============================================================================
# Node.js via Volta
# =============================================================================
log "Installing Volta for Node.js version management..."
if ! command -v volta &>/dev/null; then
    curl https://get.volta.sh | bash
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
else
    info "Volta already installed."
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
fi

if ! volta list node 2>/dev/null | grep -q 'node'; then
    log "Installing Node.js LTS and npm via Volta..."
    volta install node
    volta install npm@latest
fi

log "Installing global npm packages..."
if ! volta list 2>/dev/null | grep -q 'prettier'; then
    volta install \
        commit-and-tag-version \
        doctoc \
        eslint \
        eslint-config-prettier \
        gitlab-ci-local \
        heroku \
        mdpdf \
        neovim \
        pa11y \
        prettier \
        pyright \
        serve \
        stylelint \
        svgo \
        typescript
fi

# =============================================================================
# Rust via Rustup
# =============================================================================
log "Installing Rust via Rustup..."
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    info "Rust already installed."
    source "$HOME/.cargo/env"
fi

# =============================================================================
# Claude Code
# =============================================================================
log "Installing Claude Code..."
if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
else
    info "Claude Code already installed."
fi

# =============================================================================
# Go tools (gopls — golangci-lint is in Brewfile)
# =============================================================================
log "Installing Go tools..."
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
if ! command -v gopls &>/dev/null; then
    go install golang.org/x/tools/gopls@latest
fi

# =============================================================================
# Python tooling via pipx
# =============================================================================
log "Installing Python tools via pipx..."
export PATH="$PATH:$HOME/.local/bin"
pipx ensurepath

for pkg in poetry timetagger_cli; do
    if ! pipx list --short 2>/dev/null | grep -q "$pkg"; then
        pipx install "$pkg"
    fi
done

# Poetry shell completions
mkdir -p "$HOME/.zfunc"
poetry completions zsh > "$HOME/.zfunc/_poetry" 2>/dev/null || true

# =============================================================================
# FZF keybindings & completions
# =============================================================================
log "Setting up fzf keybindings..."
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true

# =============================================================================
# Neovim config
# =============================================================================
log "Setting up Neovim config..."
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone -b custom https://github.com/engineervix/kickstart.nvim.git "$HOME/.config/nvim"
else
    info "Neovim config already exists at ~/.config/nvim — skipping clone."
fi

# =============================================================================
# git-delta config
# =============================================================================
log "Configuring git with delta..."
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.dark true
git config --global merge.conflictStyle zdiff3

log "Development tooling setup complete."
