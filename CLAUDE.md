# unix-setup

Context for agent sessions working in this repository.

## What this repo is

A collection of machine setup resources for Victor Miti's development environments:

| Directory                                    | Purpose                                                                                                    |
| :------------------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| `_references/my-linux-setup/opensuse-setup/` | Automated setup for openSUSE Tumbleweed + Hyprland (work Linux machine)                                    |
| `_references/my-linux-setup/dotfiles/`       | Shared config files symlinked into `~/.config` on Linux (zshrc, kitty, hypr, waybar, rofi, starship, etc.) |
| current working dir                          | Automated setup for macOS (personal Mac) — mirrors the Linux setup as closely as possible                  |
| `mac-migration-plan.md`                      | Full strategy doc: tool-by-tool Linux→Mac mapping, rationale, and implementation order                     |

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

## Mac setup

Written in several sessions. **Not yet tested on a real Mac.** Review `REVIEW.md` before running.

- **WM:** AeroSpace — modifier key is `alt` (Option), mirroring `Super` on Linux
- **Focus indicator:** JankyBorders — Catppuccin Mocha coloured border on focused window; launched from AeroSpace `after-startup-command`
- **Workspace swipe:** SwipeAeroSpace — restores 3-finger trackpad swipe; needs Accessibility permission (manual)
- **Status bar:** SketchyBar (mirrors Waybar layout)
- **Launcher:** Spotlight on `Cmd+Space` (also `alt+r`) — replaces Rofi
- **Clipboard:** Maccy — replaces cliphist; Spotlight clipboard history (⌘Space 4) also available
- **Packages:** Homebrew + `Brewfile` (mirrors zypper)
- **Docker:** OrbStack (drop-in CLI replacement)
- **Shell config:** `conf/zshrc` — Mac-specific file, symlinked to `~/.zshrc`
  - Based on `dotfiles/.zshrc` but Mac-only (no platform guards needed)
  - Replaces OhMyZsh + Powerlevel10k (current Mac state) with Starship
  - All CLI replacement aliases already existed in the Mac zshrc but were commented out

### Key decisions

- `alt` not `cmd` as AeroSpace modifier — `cmd` conflicts with standard macOS shortcuts (Cmd+C, Cmd+V, Cmd+H, Cmd+W, etc.)
- Brewfile is the canonical list of everything — run `brew bundle` to sync
- `conf/` files are symlinked, not copied — edit in repo, changes are live immediately
- The Mac `zshrc` preserves all Mac-specific paths: Homebrew, GNU coreutils/sed, PostgreSQL@16, Android SDK, GDAL, Perl, Antigravity

### What the script automates vs. what's manual

**Automated:** Homebrew, all packages, Volta/Node/npm globals, Rustup, Claude Code (native installer), Go tools, pipx, Neovim clone, git-delta config, fzf keybindings, macOS defaults, zshrc + aerospace.toml + SketchyBar + Karabiner-Elements config symlinks, SketchyBar service start (Catppuccin Mocha config included), JankyBorders launch via AeroSpace startup.

**Manual:** Karabiner-Elements permission grants (System Extension, Accessibility, Login Items), Maccy hotkey setup, SwipeAeroSpace Accessibility permission, Kitty config copy, VS Code Settings Sync, pyenv Python install, all licensed/manual app installs (Office 365, Ableton, Vital, Splice, BricsCAD, NTFS for Mac, Sweet Home 3D, Antigravity).

## Conventions

- Scripts use `log` / `warn` / `info` / `error` functions with colour-coded output
- All operations are idempotent — safe to re-run
- Existing files are backed up with a timestamp before being replaced
- `SCRIPT_DIR` is exported from `install.sh` so sub-scripts can reference `${SCRIPT_DIR}/conf/`

## Working in this repo

- Run `lefthook install` once after cloning to activate pre-commit hooks (ggshield secret scan + ShellCheck on staged `.sh` files).
- The migration plan (`mac-migration-plan.md`) is the source of truth for strategy decisions. Update it when decisions change.
- `REVIEW.md` tracks open questions and items needing verification after the initial session.
- The Linux dotfiles `.zshrc` is at `dotfiles/.zshrc` — if you add a new cross-platform function there, also add it to `conf/zshrc`.
- The Mac `.zshrc` has three Mac-only functions not in the Linux dotfiles: `compress_audio`, `days_until`, `wget_entire_site`. These are worth promoting to the shared dotfiles eventually.
