#!/usr/bin/env bash
# =============================================================================
# Script: 03_tooling.sh
# Description: Sets up language runtimes, global packages, and dev tooling.
# =============================================================================

log "--- [Phase 3: Development Tooling] ---"

# =============================================================================
# Node.js via Vite+ (vp, installed by the Brewfile)
# =============================================================================
log "Setting up Vite+ for Node.js and package manager management..."
# First run does the setup: shims, shell integration, management preferences.
# The env vars answer its prompts so Vite+ manages Node and npm/pnpm/yarn/bun.
# It appends `. "$HOME/.config/vite-plus/env"` to ~/.zshenv, ~/.profile and
# ~/.zshrc (through the symlink, so conf/zshrc) unless the line is already there.
VP_NODE_MANAGER=yes VP_PM_MANAGER=yes vp help >/dev/null

# Only packages whose projects document npm as the install method. The rest
# (gitlab-ci-local, heroku, hunk, jscpd, rover) come from the Brewfile.
# pnpm is absent on purpose: Vite+ ships its own pnpm shim.
NPM_GLOBALS=(
    @vtsls/language-server
    bibtex-tidy
    ccusage
    commit-and-tag-version
    doctoc
    eslint
    eslint-config-prettier
    mdpdf
    neovim
    pa11y
    prettier
    pyright
    serve
    stylelint
    subfont
    svgo
    typescript
)

log "Installing global npm packages (each pinned to the current Node LTS)..."
installed="$(vp list -g --json | jq -r '.[].name')"
for pkg in "${NPM_GLOBALS[@]}"; do
    if grep -qxF "$pkg" <<<"$installed"; then
        info "$pkg already installed."
    else
        vp install -g --node lts "$pkg"
    fi
done

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

# Ensure cargo is available in this session
# source "$HOME/.cargo/env"
# We need this for the Neovim setup
if ! command -v tree-sitter &>/dev/null; then
    cargo install tree-sitter-cli
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
# GitHub CLI extensions
# =============================================================================
log "Installing GitHub CLI extensions..."
for ext in dlvhdr/gh-dash agynio/gh-pr-review; do
    if ! gh extension list 2>/dev/null | grep -q "$(basename "$ext")"; then
        gh extension install "$ext"
    fi
done

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
# Perl local::lib (needed by LaTeX tools and other Perl-based utilities)
# =============================================================================
log "Setting up Perl local::lib..."
if ! perl -I"$HOME/perl5/lib/perl5" -Mlocal::lib &>/dev/null; then
    PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" \
    PERL_MB_OPT="--install_base=$HOME/perl5" \
        cpanm local::lib
else
    info "Perl local::lib already configured."
fi

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
git config --global delta.side-by-side true
git config --global merge.conflictStyle zdiff3
git config --global pager.diff diffnav

# difftastic as an opt-in difftool (invoked via `git difftool`) — does not
# touch core.pager/pager.diff above, so delta/diffnav stay the defaults.
git config --global diff.tool difftastic
# shellcheck disable=SC2016 # $LOCAL/$REMOTE are expanded by git, not the shell
git config --global difftool.difftastic.cmd 'difft "$LOCAL" "$REMOTE"'

# =============================================================================
# tealdeer (tldr) page cache
# =============================================================================
log "Populating tealdeer's tldr page cache..."
tldr --update 2>/dev/null || true

log "Development tooling setup complete."
