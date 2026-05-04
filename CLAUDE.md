# CLAUDE.md — unix-setup

Context for Claude Code sessions working in this repository.

## What this repo is

A collection of machine setup resources for Victor Miti's development environments:

| Directory | Purpose |
| :--- | :--- |
| `opensuse-setup/` | Automated setup for openSUSE Tumbleweed + Hyprland (work Linux machine) |
| `dotfiles/` | Shared config files symlinked into `~/.config` on Linux (zshrc, kitty, hypr, waybar, rofi, starship, etc.) |
| `mac-setup/` | Automated setup for macOS (personal Mac) — mirrors the Linux setup as closely as possible |
| `mac-migration-plan-claude.md` | Full strategy doc: tool-by-tool Linux→Mac mapping, rationale, and implementation order |

## Linux setup (opensuse-setup + dotfiles)

- **OS:** openSUSE Tumbleweed (rolling release)
- **WM:** Hyprland (Wayland compositor)
- **Terminal:** Kitty
- **Shell:** Zsh + Starship (Catppuccin Mocha theme)
- **Editor:** Neovim (`engineervix/kickstart.nvim`, branch `custom`)
- **Theme:** Catppuccin Mocha throughout
- **Font:** JetBrainsMono Nerd Font
- **Modifier key:** `Super` (Windows key) — used for all Hyprland bindings
- The `dotfiles/` repo is symlinked, not copied — `dotfiles/install.sh` creates the symlinks

## Mac setup (mac-setup/)

Written in one session. **Not yet tested on a real Mac.** Review `REVIEW.md` before running.

- **WM:** AeroSpace — modifier key is `alt` (Option), mirroring `Super` on Linux
- **Status bar:** SketchyBar (mirrors Waybar layout)
- **Launcher:** Raycast on `Cmd+Space` (also `alt+r`) — replaces Rofi
- **Clipboard:** Raycast built-in (also Maccy as fallback) — replaces cliphist
- **Packages:** Homebrew + `Brewfile` (mirrors zypper)
- **Docker:** OrbStack (drop-in CLI replacement)
- **Shell config:** `mac-setup/conf/zshrc` — Mac-specific file, symlinked to `~/.zshrc`
  - Based on `dotfiles/.zshrc` but Mac-only (no platform guards needed)
  - Replaces OhMyZsh + Powerlevel10k (current Mac state) with Starship
  - All CLI replacement aliases already existed in the Mac zshrc but were commented out

### Key decisions

- `alt` not `cmd` as AeroSpace modifier — `cmd` conflicts with standard macOS shortcuts (Cmd+C, Cmd+V, Cmd+H, Cmd+W, etc.)
- Stats.app (already installed) as zero-config interim for SketchyBar right-side modules
- Brewfile is the canonical list of everything — run `brew bundle` to sync
- `conf/` files are symlinked, not copied — edit in repo, changes are live immediately
- The Mac `zshrc` preserves all Mac-specific paths: Homebrew, GNU coreutils/sed, PostgreSQL@16, Android SDK, GDAL, Perl, Antigravity, Kiro

### What the script automates vs. what's manual

**Automated:** Homebrew, all packages, Volta/Node/npm globals, Rustup, Go tools, pipx, Neovim clone, git-delta config, fzf keybindings, macOS defaults, zshrc + aerospace.toml symlinks, SketchyBar service start.

**Manual:** Karabiner-Elements GUI config, Raycast setup, SketchyBar Catppuccin theme, Kitty config copy, VS Code Settings Sync, pyenv Python install, all licensed/manual app installs (Office 365, Ableton, Vital, Splice, BricsCAD, NTFS for Mac, Sweet Home 3D, Antigravity).

## Conventions

- Scripts use `log` / `warn` / `info` / `error` functions with colour-coded output
- All operations are idempotent — safe to re-run
- Existing files are backed up with a timestamp before being replaced
- `SCRIPT_DIR` is exported from `install.sh` so sub-scripts can reference `${SCRIPT_DIR}/conf/`

## Working in this repo

- The migration plan (`mac-migration-plan-claude.md`) is the source of truth for strategy decisions. Update it when decisions change.
- `mac-setup/REVIEW.md` tracks open questions and items needing verification after the initial session.
- The Linux dotfiles `.zshrc` is at `dotfiles/.zshrc` — if you add a new cross-platform function there, also add it to `mac-setup/conf/zshrc`.
- The Mac `.zshrc` has three Mac-only functions not in the Linux dotfiles: `compress_audio`, `days_until`, `wget_entire_site`. These are worth promoting to the shared dotfiles eventually.
