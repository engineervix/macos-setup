# macOS Migration Plan: Replicating the Linux Environment

## 1. Objective
Create a seamless macOS environment that mirrors your Linux Hyprland/Zsh/Kitty setup as closely as possible, using open-source tools where applicable, while respecting the standard macOS keyboard layout (Command key).

## 2. Core Components & Equivalents

| Category | Linux (Hyprland Setup) | macOS Equivalent | Notes |
| :--- | :--- | :--- | :--- |
| **Window Manager** | Hyprland | **AeroSpace** | Open-source, tree-based tiling manager. Feels very similar to i3/Hyprland. Uses workspaces (1-10) and handles tiling natively without relying heavily on the slow macOS accessibility API. |
| **Terminal** | Kitty | **Kitty** | 100% compatible. We will port your `kitty.conf` and `mocha.conf` directly. |
| **Shell** | Zsh + Starship | **Zsh + Starship** | macOS default is Zsh. We will reuse your `.zshrc` with minor tweaks for macOS-specific commands (e.g., `open` instead of `xdg-open`). |
| **App Launcher** | Rofi | **Raycast** | Not open-source, but the gold standard on macOS. Replaces Rofi for launching apps, math, and searching. |
| **Clipboard** | Cliphist | **Maccy** | Open-source, lightweight clipboard manager. Alternatively, Raycast has a built-in clipboard history. |
| **Screenshots**| Grim + Slurp | **macOS Native** | Cmd+Shift+3 (Full), Cmd+Shift+4 (Region). Can be invoked via AeroSpace binds if desired. |
| **Fonts** | JetBrainsMono Nerd | **JetBrainsMono Nerd** | Installed via Homebrew. |
| **Packages** | Zypper / pacman | **Homebrew** | The default package manager for macOS. |

## 3. Implementation Steps

### Step 1: Base System & Package Management
*   Install **Homebrew**: `bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
*   Install core CLI tools via `brew`:
    *   `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `starship`, `yq`, `delta`
    *   `neovim`, `tmux`, `git`
*   Install Casks (GUI apps):
    *   `kitty`, `raycast`, `maccy`, `aerospace`, `font-jetbrains-mono-nerd-font`

### Step 2: Tiling Window Manager (AeroSpace)
*   Create `~/.aerospace.toml`.
*   Map your Hyprland bindings to AeroSpace (using `cmd` and `alt` since you opted for the standard Mac layout):
    *   `cmd + enter` / `cmd + q`: Open Kitty
    *   `cmd + c` / `cmd + w`: Close window
    *   `cmd + h/j/k/l`: Focus window directions
    *   `cmd + shift + h/j/k/l`: Move window directions
    *   `cmd + 1-9`: Switch to workspace 1-9
    *   `cmd + shift + 1-9`: Move window to workspace 1-9
    *   `cmd + v`: Toggle floating

### Step 3: Terminal & Shell Configuration
*   Symlink or copy `.config/kitty/kitty.conf` and `mocha.conf`.
*   Modify `kitty.conf` for macOS: Ensure `font_family JetBrainsMono Nerd Font` works (macOS sometimes requires the exact PostScript name, e.g., `JetBrainsMonoNL NFM`).
*   Port `.zshrc`:
    *   Remove `alias open="xdg-open"` (macOS uses `open` natively).
    *   Replace `trash='gio trash'` with `trash='trash'` (install `trash-cli` via brew).
    *   Ensure `$PATH` includes `/opt/homebrew/bin` (Apple Silicon default).

### Step 4: System Tweaks & Workflow
*   **Raycast**: Bind to `Cmd + Space` (disable macOS default Spotlight shortcut).
*   **Maccy**: Bind to `Cmd + Shift + C` for clipboard history (mimicking your `SUPER + H` cliphist).
*   Disable macOS window animations (optional, for a snappier feeling).

## 4. Verification & Testing
*   Verify AeroSpace starts and successfully tiles windows.
*   Verify Kitty launches with the Catppuccin theme and correct font.
*   Verify Zsh aliases (`ll`, `cat`, `find`, `rg`) work correctly.
*   Test window movement and workspace switching via keyboard.

## 5. Rollback Strategy
*   Since this is a new setup on a Mac, rollback consists of uninstalling AeroSpace (removing the config and quitting the app) and relying on native macOS window management (Stage Manager / Mission Control). Homebrew packages can be removed via `brew uninstall`.
