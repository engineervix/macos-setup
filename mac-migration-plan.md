# Mac Migration Plan

Mapping my openSUSE Tumbleweed / Hyprland setup to macOS, prioritising muscle-memory continuity.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Guiding Principles](#guiding-principles)
- [Stack Mapping](#stack-mapping)
- [Phase 1 — Homebrew & Core CLI](#phase-1--homebrew--core-cli)
  - [Brewfile (target)](#brewfile-target)
  - [Shell aliases to change](#shell-aliases-to-change)
- [Manual & Licensed Installs](#manual--licensed-installs)
  - [App Store](#app-store)
  - [Free — manual download](#free--manual-download)
  - [Account required](#account-required)
  - [Commercial / licensed](#commercial--licensed)
- [Phase 2 — Aerospace (Tiling WM)](#phase-2--aerospace-tiling-wm)
  - [Starter `~/.aerospace.toml`](#starter-aerospacetoml)
- [System tweak: disable window animations](#system-tweak-disable-window-animations)
- [Phase 4 — SketchyBar](#phase-4--sketchybar)
- [Phase 5 — Spotlight + Maccy](#phase-5--spotlight--maccy)
- [Phase 6 — Kitty (unchanged)](#phase-6--kitty-unchanged)
- [Phase 7 — Shell & Dotfiles](#phase-7--shell--dotfiles)
  - [Current state of the Mac zshrc](#current-state-of-the-mac-zshrc)
  - [What to remove](#what-to-remove)
  - [macOS-specific block (add inside the OS guard in `.zshrc`)](#macos-specific-block-add-inside-the-os-guard-in-zshrc)
  - [Init calls to add (outside the OS guard — these work on both platforms)](#init-calls-to-add-outside-the-os-guard--these-work-on-both-platforms)
  - [Mac-only functions to keep (not in Linux dotfiles)](#mac-only-functions-to-keep-not-in-linux-dotfiles)
  - [tar_max is already Mac-aware](#tar_max-is-already-mac-aware)
- [Phase 8 — Neovim & Editors](#phase-8--neovim--editors)
- [Phase 9 — Development Tools](#phase-9--development-tools)
- [What Cannot Be Replicated](#what-cannot-be-replicated)
- [Screenshot Keybindings (macOS native, no setup needed)](#screenshot-keybindings-macos-native-no-setup-needed)
- [Verification Checklist](#verification-checklist)
- [Rollback](#rollback)
- [Implementation Order](#implementation-order)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

## Guiding Principles

- Keep the **same modifier key feel**: Aerospace uses `alt` as main mod → mirrors `$mainMod = Super` in Hyprland
- Keep the **same shell stack** untouched: zsh, starship, all CLI tools port 1:1 via Homebrew
- Keep the **same theme**: Catppuccin Mocha across every configurable app
- Keep the **same font**: JetBrainsMono Nerd Font

---

## Stack Mapping

| Linux    | macOS Equivalent            | Notes                                                       |
| -------- | --------------------------- | ----------------------------------------------------------- |
| Hyprland | Aerospace                   | Same workspace/keybinding philosophy                        |
| Waybar   | SketchyBar                  | Fully scriptable, Catppuccin-ready                          |
| Rofi     | Spotlight (built-in)        | Native macOS launcher; no install needed                    |
| cliphist | Maccy + Spotlight clipboard | Maccy for hotkey access; Spotlight ⌘4 for cross-device sync |
| Kitty    | Kitty                       | Unchanged — native macOS support                            |
| Dunst    | macOS native                | Not customisable at daemon level                            |
| hyprlock | macOS native                | Not customisable                                            |
| swayosd  | macOS native OSD            | Volume/brightness pills built-in                            |
| zypper   | Homebrew                    | `brew bundle` = reproducible Brewfile                       |
| Docker   | OrbStack                    | Drop-in CLI replacement, much lighter                       |
| wlogout  | macOS power menu            | No equivalent needed                                        |

---

## Phase 1 — Homebrew & Core CLI

Install Homebrew first, then express the full tool list as a `Brewfile` for reproducible setup.

### Brewfile (target)

```ruby
# === Shell ===
brew "zsh"
brew "starship"
brew "zsh-syntax-highlighting"
brew "zsh-autosuggestions"
brew "zsh-completions"

# === GNU coreutils (replace macOS BSD versions) ===
brew "coreutils"         # gls, gdate, etc. — add gnubin to PATH
brew "gnu-sed"           # gsed — add gnubin to PATH

# === CLI replacements (same aliases as Linux) ===
brew "eza"
brew "bat"
brew "fd"
brew "ripgrep"
brew "fzf"
brew "zoxide"
brew "git-delta"
brew "lazygit"
brew "btop"
brew "htop"
brew "ncdu"
brew "duf"
brew "procs"
brew "bandwhich"         # network monitor
brew "fastfetch"         # system info (neofetch replacement)

# === File & archive tools ===
brew "tree"
brew "wget"
brew "pv"                # pipe viewer
brew "dos2unix"
brew "trash"             # replaces `gio trash`

# === Git & version control ===
brew "git"
brew "git-lfs"
brew "gh"
brew "glab"
brew "act"               # run GitHub Actions locally
brew "lefthook"          # Git hooks manager

# === Security & scanning ===
brew "shellcheck"
brew "ggshield"          # GitGuardian secrets scanner
brew "gnupg"
brew "trivy"             # vulnerability scanner

# === Dev utilities ===
brew "just"              # task runner (like make but saner)
brew "httpie"            # HTTP client
brew "yq"                # YAML processor
brew "tmux"              # for SSH sessions / remote work
brew "vim"               # fallback editor

# === Languages & runtimes ===
brew "go"
brew "ruby"
brew "deno"
brew "pyenv"
# Volta (Node): curl https://get.volta.sh | bash
# Rustup:       curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# === Python tooling ===
brew "pipx"
brew "virtualenvwrapper"

# === Go tools ===
brew "golangci-lint"

# === Lua (for Neovim) ===
brew "lua@5.4"
brew "luajit"

# === Database ===
brew "postgresql@16"

# === Cloud & infra ===
brew "awscli"
brew "azure-cli"
brew "terraform"
brew "rclone"            # cloud sync

# === Document & PDF processing ===
brew "pandoc"
brew "pdftk-java"
brew "ghostscript"
brew "img2pdf"
brew "ocrmypdf"
brew "tesseract"
brew "unpaper"           # for document scanning (gscan2pdf equivalent)

# === Image & media ===
brew "imagemagick"
brew "ffmpeg"
brew "yt-dlp"
brew "exiftool"

# === Geospatial (GIS work) ===
brew "gdal"
brew "proj"

# === Presentation ===
brew "marp-cli"          # Markdown presentations (same as Linux)

# === AI CLIs ===
brew "gemini-cli"

# === Notifications ===
brew "terminal-notifier"

# === Fonts ===
cask "font-jetbrains-mono-nerd-font"
cask "font-cascadia-code"
cask "font-cascadia-code-pl"
cask "font-fantasque-sans-mono-nerd-font"

# === Terminal & WM ===
cask "kitty"
cask "aerospace"
cask "karabiner-elements"
cask "sketchybar"
cask "maccy"             # clipboard manager (complements Spotlight clipboard history)

# === Browsers ===
cask "google-chrome"
cask "brave-browser"
cask "firefox"
cask "ungoogled-chromium"

# === Editors & IDEs ===
cask "visual-studio-code"
cask "zed"
cask "sublime-text"
cask "android-studio"
# === Communication ===
cask "slack"
cask "zoom"

# === Dev tools ===
cask "orbstack"          # Docker Desktop replacement
cask "meld"              # visual diff

# === System utilities ===
cask "stats"             # menu bar system monitor (lightweight Waybar alternative)
cask "aldente"           # battery charge limiter
cask "tailscale"         # mesh VPN
cask "mullvad-vpn"       # VPN

# === Creative & media ===
cask "vlc"
cask "spotify"
cask "gimp"
cask "inkscape"
cask "blender"
cask "musescore"         # music notation

# === R & data science ===
cask "r"
cask "rstudio"

# === Java (required for Android dev) ===
cask "zulu@17"
```

### Shell aliases to change

```zsh
# Remove — macOS has native `open`:
# alias open='xdg-open'

# Replace gio trash with the `trash` cask:
alias trash='trash'

# Everything else in .zshrc is unchanged
```

---

## Manual & Licensed Installs

These cannot be managed by Homebrew. Document them here so nothing gets forgotten.

### App Store

| App   | Notes                                                          |
| ----- | -------------------------------------------------------------- |
| Xcode | Install first; then run `xcode-select --install` for CLI tools |

### Free — manual download

| App           | Source          | Notes                                            |
| ------------- | --------------- | ------------------------------------------------ |
| Sweet Home 3D | sweethome3d.com | No cask available                                |
| Vital         | vital.audio     | Free synth plugin; account required for download |

### Account required

| App                  | Source      | Notes                                                                                                                                             |
| -------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ableton Live 12 Lite | ableton.com | Lite license comes with hardware; activate via Ableton account                                                                                    |
| Splice INSTRUMENT    | splice.com  | Plugin manager; requires Splice account                                                                                                           |
| Antigravity          | custom      | Installed to `~/.antigravity/antigravity/bin/` via its own installer; re-run the original install script and ensure the PATH entry is in `.zshrc` |

### Commercial / licensed

| App                                                                 | Notes                                                                        |
| ------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Microsoft 365 (Word, Excel, PowerPoint, Outlook, OneNote, OneDrive) | Sign in via microsoft.com or Mac App Store with work/personal account        |
| BricsCAD                                                            | bricsys.com — commercial CAD; requires license key                           |
| NTFS for Mac                                                        | Commercial (Paragon NTFS or similar); required for read/write on NTFS drives |

---

## Phase 2 — Aerospace (Tiling WM)

Config file lives at `~/.aerospace.toml`. Target keybinding map:

| Hyprland           | Aerospace        | Action                   |
| ------------------ | ---------------- | ------------------------ |
| `Super+Q`          | `alt+q`          | Launch Kitty             |
| `Super+C`          | `alt+c`          | Close window             |
| `Super+V`          | `alt+v`          | Toggle float             |
| `Super+1-0`        | `alt+1-0`        | Switch workspace         |
| `Super+Shift+1-0`  | `alt+shift+1-0`  | Move window to workspace |
| `Super+Tab`        | `alt+tab`        | Previous workspace       |
| `Super+arrow keys` | `alt+arrows`     | Move focus               |
| `Super+Shift+hjkl` | `alt+shift+hjkl` | Move window              |
| `Super+W`          | `alt+w`          | Enter resize mode        |

### Starter `~/.aerospace.toml`

```toml
after-login-command = []
after-startup-command = []

start-at-login = true

[mode.main.binding]
alt-q = 'exec-and-forget open -a Kitty'
alt-c = 'close'
alt-v = 'layout floating tiling'  # toggle float

alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'

alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'

alt-1 = 'workspace 1'
alt-2 = 'workspace 2'
alt-3 = 'workspace 3'
alt-4 = 'workspace 4'
alt-5 = 'workspace 5'
alt-6 = 'workspace 6'
alt-7 = 'workspace 7'
alt-8 = 'workspace 8'
alt-9 = 'workspace 9'
alt-0 = 'workspace 10'

alt-shift-1 = 'move-node-to-workspace 1'
alt-shift-2 = 'move-node-to-workspace 2'
alt-shift-3 = 'move-node-to-workspace 3'
alt-shift-4 = 'move-node-to-workspace 4'
alt-shift-5 = 'move-node-to-workspace 5'
alt-shift-6 = 'move-node-to-workspace 6'
alt-shift-7 = 'move-node-to-workspace 7'
alt-shift-8 = 'move-node-to-workspace 8'
alt-shift-9 = 'move-node-to-workspace 9'
alt-shift-0 = 'move-node-to-workspace 10'

alt-tab = 'workspace-back-and-forth'

# Resize mode
alt-w = 'mode resize'

[mode.resize.binding]
h = 'resize width -50'
j = 'resize height +50'
k = 'resize height -50'
l = 'resize width +50'
enter = 'mode main'
esc = 'mode main'

# Workspace → app assignments (mirrors Hyprland rules.conf)
[[on-window-detected]]
if.app-id = 'com.google.Chrome'
run = 'move-node-to-workspace 1'

[[on-window-detected]]
if.app-id = 'com.tinyspeck.slackmacgap'
run = 'move-node-to-workspace 3'
```

---

## System tweak: disable window animations

macOS animations can feel sluggish compared to Hyprland. Run once to disable them:

```sh
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock
```

---

## Phase 4 — SketchyBar

Replaces Waybar. Hides the native macOS menu bar.

Target modules (mirrors Waybar layout):

| Position | Module               | Notes                      |
| -------- | -------------------- | -------------------------- |
| Left     | Aerospace workspaces | Active workspace highlight |
| Centre   | Active window title  | Truncated to ~50 chars     |
| Right    | Clock                | HH:MM:SS format            |
| Right    | Network              | Up/down indicator          |
| Right    | Battery              | % + charging state         |
| Right    | CPU                  | Usage %                    |
| Right    | Memory               | Usage %                    |
| Right    | Volume               | Level + mute state         |

Catppuccin Mocha colours: use the community `catppuccin/sketchybar` preset.

**Note:** Stats.app is already installed and covers the right-side modules (CPU, memory, battery, network, disk) with zero config. Use it as an interim solution while SketchyBar is being set up — or keep it permanently if SketchyBar feels like too much maintenance overhead. The one thing Stats.app can't do is show Aerospace workspace indicators on the left, so SketchyBar (or at minimum its workspace plugin alone) is still worth setting up.

---

## Phase 5 — Spotlight + Maccy

Replaces Rofi + cliphist. No additional install needed for Spotlight — it's built into macOS.

- `Cmd+Space` opens Spotlight; `alt+r` in AeroSpace also triggers it (via osascript keystroke)
- Spotlight browse modes: Apps (⌘1), Files (⌘2), Actions (⌘3), Clipboard (⌘4)
- Maccy is installed via Brewfile — set hotkey to `cmd+shift+v` in its preferences (`alt+h` is taken by AeroSpace focus-left)

---

## Phase 6 — Kitty (unchanged)

Copy `~/.config/kitty/` directly. The `mocha.conf` theme and font config are fully cross-platform.

**Font name caveat:** macOS sometimes requires the PostScript name rather than the family name. If the font doesn't render, change `kitty.conf`:

```
# Linux (works on both):
font_family JetBrainsMono Nerd Font

# macOS fallback if the above fails:
font_family JetBrainsMonoNL NFM
```

The only other likely change: if any config references a Linux-specific binary or path (e.g. `xdg-open`), replace with macOS equivalent.

---

## Phase 7 — Shell & Dotfiles

### Current state of the Mac zshrc

The current Mac `.zshrc` (OhMyZsh + Powerlevel10k) already has all the right CLI aliases written — they're just commented out. The migration is mostly:

1. Strip out OhMyZsh/p10k entirely
2. Uncomment the aliases
3. Add the missing init calls (starship, fzf, zoxide)
4. Preserve all the Mac-specific paths and env vars
5. Remove iTerm2 shell integration line (switching to Kitty)

### What to remove

```zsh
# Remove these entire blocks:
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(...)
source $ZSH/oh-my-zsh.sh

# Remove iTerm2 integration:
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Remove p10k:
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then ...
```

### macOS-specific block (add inside the OS guard in `.zshrc`)

```zsh
if [[ "$(uname)" == "Darwin" ]]; then
  # Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # GNU coreutils and sed (override macOS BSD versions)
  PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"

  # PostgreSQL
  export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/postgresql@16/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/postgresql@16/include"

  # Android dev
  export ANDROID_HOME="$HOME/Android/Sdk"
  export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
  export PATH="$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools"

  # GDAL (update version number after each gdal upgrade)
  export GDAL_LIBRARY_PATH="$(brew --prefix gdal)/lib/libgdal.dylib"

  # Homebrew C headers (needed by some Python packages)
  export CFLAGS="-I/opt/homebrew/include"
  export LDFLAGS="${LDFLAGS} -L/opt/homebrew/lib"

  # Homebrew Perl
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

  # Antigravity
  export PATH="/Users/victor/.antigravity/antigravity/bin:$PATH"

  # Remove xdg-open alias — macOS `open` is native
  unalias open 2>/dev/null

  # Fix trash alias
  alias trash='trash'

  # Zsh plugins (sourced here since they're Homebrew-managed on macOS)
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
```

### Init calls to add (outside the OS guard — these work on both platforms)

```zsh
# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Zoxide
eval "$(zoxide init zsh)"

# Starship (replaces p10k)
eval "$(starship init zsh)"
```

### Mac-only functions to keep (not in Linux dotfiles)

These are in the current Mac `.zshrc` and worth preserving — either keep them Mac-only in the OS guard, or promote them to the shared dotfiles:

```zsh
compress_audio() {
    # Compress audio file to MP3 using libmp3lame
    # Usage: compress_audio <input> [output]
    ...
}

days_until() {
    # Days until a given date
    # Usage: days_until "25 Dec 2025"
    # Uses gdate on macOS (via coreutils), date on Linux
    ...
}

wget_entire_site() {
    wget --continue --mirror --convert-links --adjust-extension \
         --page-requisites --no-parent "$1"
}
```

`days_until` already uses `gdate`/`date` detection so it's cross-platform. `compress_audio` and `wget_entire_site` work on both — consider adding them to the shared Linux dotfiles too.

### tar_max is already Mac-aware

The current Mac version of `tar_max` excludes `.DS_Store` and `__MACOSX` — ensure these are in the shared dotfiles version too:

```zsh
tar_max() {
  tar --exclude='.DS_Store' \
      --exclude='__MACOSX' \
      --exclude='node_modules' \
      --exclude='__pycache__' \
      --exclude='*.pyc' \
      -cv "$1" | xz -3e > "$2".tar.xz
}
```

---

## Phase 8 — Neovim & Editors

- Clone `engineervix/kickstart.nvim` (branch: `custom`) to `~/.config/nvim/` — identical to Linux
- VS Code: sign in to Settings Sync — extensions and keybindings restore automatically
- Zed: config at `~/.config/zed/settings.json` — copy directly from Linux dotfiles

---

## Phase 9 — Development Tools

| Tool                      | Mac setup                                                               |
| ------------------------- | ----------------------------------------------------------------------- | --------------------- |
| Docker / Compose          | OrbStack (CLI-compatible, `docker` and `docker compose` work unchanged) |
| AWS CLI                   | `brew install awscli`                                                   |
| Heroku CLI                | `brew install heroku`                                                   |
| pyenv + virtualenvwrapper | `brew install pyenv`, then pip install virtualenvwrapper                |
| Volta (Node)              | `curl https://get.volta.sh                                              | bash` (same as Linux) |
| Rustup                    | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs              | sh` (same as Linux)   |
| Go                        | `brew install go`                                                       |

All global npm packages (prettier, eslint, typescript, pyright, etc.) reinstall via `volta install` after Volta is set up.

---

## What Cannot Be Replicated

| Feature                    | Reason                                       |
| -------------------------- | -------------------------------------------- |
| Custom hyprlock lockscreen | macOS lock screen is not user-customisable   |
| Dunst notification styling | macOS notification daemon is not replaceable |
| swayosd OSD                | macOS has a fixed native OSD                 |
| GPU screen recorder script | Use macOS built-in `Cmd+Shift+5`             |
| Monitor hot-plug scripts   | macOS handles display changes automatically  |
| Wayland-native clipboard   | Maccy + Spotlight clipboard (⌘Space → ⌘4)    |

---

## Screenshot Keybindings (macOS native, no setup needed)

| Action                 | macOS              | Linux equivalent    |
| ---------------------- | ------------------ | ------------------- |
| Full screenshot → file | `Cmd+Shift+3`      | `Print`             |
| Selection → file       | `Cmd+Shift+4`      | `Super+Shift+Print` |
| Selection → clipboard  | `Cmd+Ctrl+Shift+4` | `Super+Print`       |
| Screen recording UI    | `Cmd+Shift+5`      | `Super+Shift+R`     |

---

## Verification Checklist

Run through these after each phase to confirm nothing is broken before moving on.

- [ ] Aerospace tiles windows and `alt+1-0` switches workspaces correctly
- [ ] `alt+h/j/k/l` moves focus; `alt+shift+h/j/k/l` moves windows
- [ ] Kitty launches via `alt+q` with Catppuccin Mocha theme and correct font
- [ ] Spotlight opens on `Cmd+Space` and `alt+r`; Maccy clipboard history on `cmd+shift+v`
- [ ] SketchyBar shows workspaces, clock, CPU, memory, battery
- [ ] `ll`, `cat`, `find`, `rg` aliases all resolve correctly in a new shell
- [ ] `docker ps` and `docker compose` work via OrbStack
- [ ] `python --version` and `node --version` return pyenv/Volta-managed versions
- [ ] Neovim opens with plugins loaded and Catppuccin Mocha theme

---

## Rollback

Since this is a fresh Mac setup, rollback is straightforward:

- **Aerospace**: quit the app and remove `~/.aerospace.toml` — macOS reverts to native Mission Control
- **SketchyBar**: `brew services stop sketchybar` and re-enable the native menu bar (`System Settings → Control Centre`)
- **Homebrew packages**: `brew uninstall <package>` or `brew bundle cleanup` against the Brewfile
- **Shell changes**: the OS-guard block in `.zshrc` is self-contained — remove it to revert

---

## Implementation Order

1. [ ] Install Xcode from App Store + run `xcode-select --install`
2. [ ] Install Homebrew
3. [ ] Create and run `Brewfile`
4. [ ] Install Volta, Rustup via curl scripts
5. [ ] Install global npm packages via Volta (`prettier`, `eslint`, `typescript`, `pyright`, etc.)
6. [ ] Configure Aerospace (`~/.aerospace.toml`)
8. [ ] Configure Raycast (hotkeys, clipboard history)
9. [ ] Configure SketchyBar (Catppuccin theme + modules) — use Stats.app in the meantime
10. [ ] Copy Kitty config; fix font name if needed (`JetBrainsMonoNL NFM`)
11. [ ] Adapt `.zshrc`: strip OhMyZsh/p10k, uncomment aliases, add OS guard block + init calls
12. [ ] Clone Neovim config (`engineervix/kickstart.nvim`, branch `custom`)
13. [ ] Set up pyenv + virtualenvwrapper; install pipx packages
14. [ ] Verify OrbStack: `docker ps`, `docker compose version`
15. [ ] Configure Zed and VS Code (Settings Sync)
16. [ ] Manual installs: Office 365, Ableton, Vital, Splice, BricsCAD, NTFS for Mac, Sweet Home 3D, Antigravity
