# macOS Developer Setup

[![forthebadge](https://forthebadge.com/badges/works-on-my-machine.svg)](https://forthebadge.com)

![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

Automated setup script for macOS, establishing a development environment that _attempts_ to mirror my [openSUSE Tumbleweed](https://github.com/engineervix/opensuse-setup) / [Hyprland](https://github.com/engineervix/dotfiles) setup as closely as possible — same shell stack, same theme, same muscle memory.

See [`docs/notes/mac-migration-plan.md`](./docs/notes/mac-migration-plan.md) for the full rationale and tool-by-tool mapping.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Stack](#stack)
- [Installation](#installation)
- [Prerequisites](#prerequisites)
- [Post-Installation](#post-installation)
  - [Maccy (Clipboard Manager)](#maccy-clipboard-manager)
  - [SketchyBar](#sketchybar)
  - [SwipeAeroSpace](#swipeaerospace)
  - [Kitty](#kitty)
  - [pyenv](#pyenv)
  - [VS Code](#vs-code)
  - [Neovim](#neovim)
  - [UK External Keyboard (e.g. Logitech K270)](#uk-external-keyboard-eg-logitech-k270)
- [Manual Installs](#manual-installs)
- [Keybindings](#keybindings)
  - [AeroSpace (Window Manager)](#aerospace-window-manager)
  - [Spotlight / Maccy / Screenshots](#spotlight--maccy--screenshots)
- [Further Reading](#further-reading)
- [Directory Structure](#directory-structure)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Stack

| Component           | Linux             | macOS                                                       |
| :------------------ | :---------------- | :---------------------------------------------------------- |
| **Window Manager**  | Hyprland          | [AeroSpace](https://github.com/nikitabobko/AeroSpace)       |
| **Status Bar**      | Waybar            | [SketchyBar](https://github.com/FelixKratz/SketchyBar)      |
| **Launcher**        | Rofi              | Spotlight (built-in)                                        |
| **Terminal**        | Kitty             | Kitty (unchanged)                                           |
| **Shell**           | Zsh + Starship    | Zsh + Starship (unchanged)                                  |
| **Editor**          | Neovim            | Neovim (unchanged)                                          |
| **Packages**        | zypper            | Homebrew                                                    |
| **Docker**          | Docker            | OrbStack                                                    |
| **Focus indicator** | Hyprland built-in | [JankyBorders](https://github.com/FelixKratz/JankyBorders)  |
| **Workspace swipe** | —                 | [SwipeAeroSpace](https://github.com/MediosZ/SwipeAeroSpace) |
| **Theme**           | Catppuccin Mocha  | Catppuccin Mocha                                            |

**Modifier key:** `alt` (Option) in AeroSpace mirrors `Super` (Windows key) in Hyprland. See [keybindings](#keybindings).

## Installation

```bash
git clone <this-repo>
# cd into the cloned repo directory
chmod +x install.sh scripts/*.sh
./install.sh
```

The script runs four modular phases in sequence:

| Phase | Script            | What it does                                                                            |
| :---- | :---------------- | :-------------------------------------------------------------------------------------- |
| 1     | `01_preflight.sh` | Checks Xcode CLI tools; applies macOS system defaults                                   |
| 2     | `02_homebrew.sh`  | Installs Homebrew; runs `Brewfile`                                                      |
| 3     | `03_tooling.sh`   | Installs Volta/Node/npm, Rustup, Claude Code, Go tools, pipx packages, Neovim config, fzf, git-delta |
| 4     | `04_dotfiles.sh`  | Clones dotfiles repo; symlinks `zshrc`, `aerospace.toml`, Starship, Kitty, and SketchyBar config; starts SketchyBar service |

Safe to re-run — all steps are idempotent.

## Prerequisites

- macOS (Apple Silicon assumed — `/opt/homebrew`)
- Xcode installed from the Mac App Store (the script handles the CLI tools)
- Internet connection

## Post-Installation

These steps require a GUI or credentials and cannot be automated.

### Maccy (Clipboard Manager)

Maccy is installed by the Brewfile. On first launch, set a hotkey in Maccy preferences — suggested `cmd+shift+v` (`alt+h` is taken by AeroSpace focus-left). Adjust history size and ignored apps to taste.

Spotlight also has built-in clipboard history (`Cmd+Space` then `⌘4`), synced across devices via iCloud.

### SketchyBar

Config is provided in `conf/sketchybar/` and symlinked by the install script. It shows AeroSpace workspace indicators and active app name on the left, and clock, network, volume, and battery on the right — all Catppuccin Mocha.

If the bar doesn't appear after install:

```bash
brew services restart sketchybar
```

If icons look wrong, confirm `JetBrainsMono Nerd Font` is installed (it should be — it's in the Brewfile as `font-jetbrains-mono-nerd-font`).

### SwipeAeroSpace

Grant Accessibility permission when prompted on first launch, or manually:
`System Settings → Privacy & Security → Accessibility → SwipeAeroSpace`

### Kitty

Config is symlinked automatically from `~/dotfiles/.config/kitty`. If the font doesn't render, change `kitty.conf`:

```
font_family JetBrainsMonoNL NFM
```

### pyenv

```bash
pyenv install <your-version>
pyenv global <your-version>
```

### VS Code

Sign in to **Settings Sync** to restore extensions and keybindings.

### Neovim

On first launch, Lazy.nvim will install plugins automatically.

### UK External Keyboard (e.g. Logitech K270)

The built-in **British PC** input source swaps the `\` and `` ` `` keys, making the keyboard unusable. The fix is a custom keyboard layout from [GeorgeColdham/Mac-Uk-Keyboard-Layouts](https://github.com/GeorgeColdham/Mac-Uk-Keyboard-Layouts).

1. Clone the repo and copy the layouts to the system keyboard directory:

   ```bash
   git clone https://github.com/GeorgeColdham/Mac-Uk-Keyboard-Layouts.git /tmp/Mac-Uk-Keyboard-Layouts
   sudo cp /tmp/Mac-Uk-Keyboard-Layouts/layouts/* /Library/Keyboard\ Layouts/
   ```

2. Go to **System Settings → Keyboard → Input Sources**, click `+`, scroll to **Others** at the bottom, and add the layout from there.

3. Enable **Show Input menu in menu bar** so you can quickly switch between the external UK layout and the built-in keyboard layout.

Log out and back in if the layout doesn't appear under Others.

## Manual Installs

These apps have no Homebrew cask. See the migration plan for details.

| App                  | Source                        | Notes                                                |
| :------------------- | :---------------------------- | :--------------------------------------------------- |
| Xcode                | Mac App Store                 | Install before running script                        |
| Microsoft 365        | microsoft.com / Mac App Store | Word, Excel, PowerPoint, Outlook, OneNote, OneDrive  |
| Ableton Live 12 Lite | ableton.com                   | Lite license; activate via Ableton account           |
| Vital                | vital.audio                   | Free synth plugin; requires account                  |
| Splice INSTRUMENT    | splice.com                    | Plugin manager; requires account                     |
| BricsCAD             | bricsys.com                   | Commercial CAD; requires license key                 |
| NTFS for Mac         | Paragon or similar            | Commercial; needed for NTFS read/write               |
| Sweet Home 3D        | sweethome3d.com               | Free; no cask available                              |

## Keybindings

### AeroSpace (Window Manager)

| Action                               | macOS                     | Linux equivalent    |
| :----------------------------------- | :------------------------ | :------------------ |
| Launch terminal                      | `alt+q`                   | `Super+Q`           |
| Close window                         | `alt+c`                   | `Super+C`           |
| App launcher (Spotlight)             | `alt+r`                   | `Super+R`           |
| File manager (Finder)                | `alt+e`                   | `Super+E`           |
| Toggle float                         | `alt+v`                   | `Super+V`           |
| Switch workspace                     | `alt+1-0`                 | `Super+1-0`         |
| Move to workspace                    | `alt+shift+1-0`           | `Super+Shift+1-0`   |
| Previous workspace                   | `alt+tab`                 | `Super+Tab`         |
| Move workspace to next monitor       | `alt+shift+tab`           | `Super+Shift+Right` |
| Move focus                           | `alt+hjkl` / `alt+arrows` | `Super+arrows`      |
| Move window                          | `alt+shift+hjkl`          | `Super+Shift+hjkl`  |
| Resize mode                          | `alt+w`                   | `Super+W`           |
| Screenshot → clipboard               | `alt+shift+s`             | `Super+Print`       |
| Service mode (reload / reset / join) | `alt+shift+;`             | —                   |

### Spotlight / Maccy / Screenshots

| Action                 | macOS                           | Linux equivalent    |
| :--------------------- | :------------------------------ | :------------------ |
| App launcher           | `Cmd+Space` or `alt+r`          | `Super+R`           |
| Clipboard history      | `cmd+shift+v` (set in Maccy)    | `Super+H`           |
| Spotlight clipboard    | `Cmd+Space` → `⌘4`             | —                   |
| Full screenshot → file | `Cmd+Shift+3`                   | `Print`             |
| Region → file          | `Cmd+Shift+4`                   | `Super+Shift+Print` |
| Region → clipboard     | `alt+shift+s` (AeroSpace)       | `Super+Print`       |
| Screen recording       | `Cmd+Shift+5`                   | `Super+Shift+R`     |

## Further Reading

AeroSpace community write-ups that informed this config:

- [imfing.com — AeroSpace tiling window manager](https://imfing.com/til/aerospace-tiling-window-manager/)
- [vinayakg.dev — Tiling manager AeroSpace on macOS](https://vinayakg.dev/blog/tiling-manager-aerospace-mac-os) — layout normalization, balance-sizes
- [jneidel.com — AeroSpace window management guide](https://jneidel.com/guide/aerospace-window-management/) — comprehensive reference
- [ryan.himmelwright.net — Been using AeroSpace WM](https://ryan.himmelwright.net/post/been-using-aerospace-wm/) — JankyBorders, multi-monitor tips
- [roguelazer.com — AeroSpace](https://www.roguelazer.com/blog/2026-02-aerospace/) — SwipeAeroSpace discovery

## Directory Structure

```
.
├── install.sh            Orchestrator
├── Brewfile              Homebrew package manifest
├── conf/
│   ├── zshrc             Shell config → symlinked to ~/.zshrc
│   ├── aerospace.toml    AeroSpace config → symlinked to ~/.aerospace.toml
│   └── sketchybar/       SketchyBar config → symlinked to ~/.config/sketchybar/
│       ├── sketchybarrc
│       └── plugins/
│           ├── aerospace.sh
│           ├── battery.sh
│           ├── clock.sh
│           ├── front_app.sh
│           ├── network.sh
│           └── volume.sh
├── scripts/
│   ├── 01_preflight.sh
│   ├── 02_homebrew.sh
│   ├── 03_tooling.sh
│   └── 04_dotfiles.sh
├── README.md
└── docs/
    ├── _config.yml       Jekyll / GitHub Pages config
    ├── Gemfile
    ├── index.md
    ├── cheatsheets/
    │   └── aerospace-cheatsheet.html
    └── notes/
        ├── mac-migration-plan.md  Strategy doc: tool-by-tool Linux→Mac mapping
        └── review.md              Pre-run checklist and known gaps
```


