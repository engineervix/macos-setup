# macOS Developer Setup

![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

Automated setup script for macOS, establishing a development environment that mirrors my openSUSE Tumbleweed / Hyprland setup as closely as possible — same shell stack, same theme, same muscle memory.

See [`mac-migration-plan.md`](./mac-migration-plan.md) for the full rationale and tool-by-tool mapping.

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

### Karabiner-Elements

The Caps Lock remap (Escape when tapped, Ctrl when held) is configured automatically via `conf/karabiner/karabiner.json`, symlinked by the install script.

After install you must grant three permissions manually — Karabiner won't function without them:

1. **System Extension:** `System Settings → Login Items & Extensions → Driver Extensions` → approve `org.pqrs.Karabiner-DriverKit-VirtualHIDDevice`
2. **Accessibility:** `System Settings → Privacy & Security → Accessibility` → enable Karabiner-Elements
3. **Login Items:** confirm background services are enabled in `System Settings → General → Login Items`

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
| Antigravity          | custom installer              | Re-run original installer; PATH entry is in `.zshrc` |

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
- [danieltenner.com — Omarchy on macOS: AeroSpace + Karabiner](https://danieltenner.com/omarchy-on-macos-aerospace-karabiner-setup-guide-for-claude-code/) — JankyBorders Catppuccin colours, service-mode patterns

## Directory Structure

```
.
├── install.sh            Orchestrator
├── Brewfile              Homebrew package manifest
├── conf/
│   ├── zshrc             Shell config → symlinked to ~/.zshrc
│   ├── aerospace.toml    AeroSpace config → symlinked to ~/.aerospace.toml
│   ├── karabiner/        Karabiner-Elements config → symlinked to ~/.config/karabiner/
│   │   └── karabiner.json
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
└── REVIEW.md             Session notes and items needing manual verification
```
