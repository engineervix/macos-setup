---
title: Review Notes
parent: Notes
nav_order: 2
---

# Review Notes

{: .warning }
> Ongoing notes on setup quirks, known gaps, and items needing manual verification.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [What was produced](#what-was-produced)
- [Items needing verification before running](#items-needing-verification-before-running)
  - [Brewfile cask names](#brewfile-cask-names)
  - [zshrc: GDAL path](#zshrc-gdal-path)
  - [zshrc: Perl local::lib](#zshrc-perl-locallib)
  - [zshrc: Antigravity PATH](#zshrc-antigravity-path)
  - [Android SDK paths](#android-sdk-paths)
  - [git-delta: dark mode assumption](#git-delta-dark-mode-assumption)
- [Testing order (recommended)](#testing-order-recommended)
- [Known gaps](#known-gaps)
- [Items to consider adjusting](#items-to-consider-adjusting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

## What was produced

| File                      | Status   |
| :------------------------ | :------- |
| `install.sh`              | Tested   |
| `Brewfile`                | Tested   |
| `scripts/01_preflight.sh` | Tested   |
| `scripts/02_homebrew.sh`  | Tested   |
| `scripts/03_tooling.sh`   | Tested   |
| `scripts/04_dotfiles.sh`  | Tested   |
| `conf/zshrc`              | Tested   |
| `conf/aerospace.toml`     | Verified |

The `Brewfile` was built from the output of `brew list --formula` and `brew list --cask` on the current Mac, plus additions from the Linux setup. It reflects what _should_ be installed, not necessarily what exact cask/formula names Homebrew uses today.

---

## Items needing verification before running

### Brewfile cask names

These casks may have different names or may not exist — verify with `brew search` before running:

- ~~`cask "sketchybar"`~~ — **resolved**: sketchybar is a formula not a cask; changed to `brew "sketchybar"` under `tap "FelixKratz/formulae"`
- ~~`cask "aerospace"`~~ — **resolved**: lives in `nikitabobko/tap`; tap added to Brewfile
- ~~`cask "aldente"`~~ — **resolved**: cask exists
- ~~`cask "mullvad-vpn"`~~ — **resolved**: cask exists
- ~~`cask "ungoogled-chromium"`~~ — **resolved**: cask exists, no tap needed

To check any cask before installing: `brew info --cask <name>`

### zshrc: GDAL path

The zshrc has:

```zsh
export GDAL_LIBRARY_PATH="$(brew --prefix gdal)/lib/libgdal.dylib"
```

This evaluates `brew --prefix gdal` each time the shell starts. If GDAL is not installed yet when the shell first loads (e.g., between Homebrew install and Brewfile run), it will silently fail. After the full setup, open a new terminal and verify:

```bash
echo $GDAL_LIBRARY_PATH
ls "$GDAL_LIBRARY_PATH"
```

### zshrc: Perl local::lib

```zsh
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
```

This will fail silently if `$HOME/perl5` doesn't exist. That's fine — it only matters if you use Perl. Verify after setup if you use Perl packages.

### zshrc: Antigravity PATH

```zsh
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
```

This path is hardcoded based on what was in the current Mac zshrc. If Antigravity is not installed, this silently adds a non-existent directory to PATH (harmless). Re-install Antigravity via its own installer if needed.

### Android SDK paths

The zshrc sets `ANDROID_HOME` and `ANDROID_SDK_ROOT` to `~/Android/Sdk`. Android Studio creates this on first launch. The paths will fail silently until Android Studio is set up — harmless.

### git-delta: dark mode assumption

`03_tooling.sh` runs:

```bash
git config --global delta.dark true
```

If you use a light theme terminal, change this to `delta.light true` or remove it to let delta auto-detect.

---

## Testing order (recommended)

Run phases individually first rather than the full `./install.sh`:

```bash
# Phase 1 only — low risk (macOS defaults + directory creation):
source scripts/01_preflight.sh

# Phase 2 — install Homebrew and packages:
# Run with caution if Homebrew already installed; brew bundle is safe to re-run
source scripts/02_homebrew.sh

# Phase 3 — tooling (Volta, Rustup, npm, Neovim, etc.):
# Safe to run; all steps check if already installed
source scripts/03_tooling.sh

# Phase 4 — dotfiles (symlinks):
# Backs up existing files before replacing — review the backup before deleting
source scripts/04_dotfiles.sh
```

Note: Sourcing directly means `log`/`warn`/`info`/`error` functions need to be defined first.
The proper way to run a single phase:

```bash
SCRIPT_DIR="$(pwd)" source scripts/01_preflight.sh
```

---

## Known gaps

- ~~**SketchyBar font**~~ — **resolved**: `JetBrainsMono Nerd Font` confirmed registered by `fc-list`; matches exactly what `sketchybarrc` uses.
- **Neovim** — cloned on first run; Lazy.nvim will pull plugins on first `nvim` launch. This takes a few minutes and requires internet.
- **GPG/keyring** — `gnupg` and `pinentry-mac` are in the Brewfile but GPG key import and keychain setup are not automated.
- **SSH keys** — the Linux zshrc uses `keychain` for SSH agent management. The Mac zshrc omits this entirely (macOS handles SSH keys via the system Keychain). If you need `ssh-add`, configure it manually or add to `.zshrc.local`.
- **pyenv Python version** — the script installs pyenv but not a specific Python version. You must run `pyenv install <version> && pyenv global <version>` manually.
- **virtualenvwrapper** — depends on a pyenv-managed Python being set as global. Run the virtualenvwrapper setup after pyenv is configured.
- ~~**Starship config**~~ — **resolved**: `04_dotfiles.sh` now clones `engineervix/dotfiles.git` to `~/dotfiles` automatically before symlinking.
- ~~**Kitty config**~~ — **resolved**: same as above.

---

## Items to consider adjusting

- **`01_preflight.sh` macOS defaults** — the Dock is emptied (`persistent-apps -array`). If you want to keep your current Dock layout, remove or comment out that line.
- **`conf/zshrc`: `alias cd='z'`** — this replaces the built-in `cd` with zoxide globally. If you find this breaks anything, remove the alias and use `z` explicitly.
- **`conf/zshrc`: `alias diff='...'`** — this shadows the system `diff`. The function uses `delta` for output; ensure that's desirable.
- **`conf/aerospace.toml`** — the window app assignments (Chrome → workspace 1, Slack → workspace 3) may conflict with your actual usage pattern. Adjust `on-window-detected` entries to match how you work.
- **npm global packages** — the list in `03_tooling.sh` is taken from the Linux setup. Review and trim if some of those packages are no longer needed.
- **Homebrew Caskroom `.pkg` files** — when Homebrew installs a cask via a `.pkg` (e.g. `mactex-no-gui`, `android-studio`), it permanently keeps the original installer in `/opt/homebrew/Caskroom/`. `brew cleanup` deliberately ignores these. For large casks this adds up fast (e.g. mactex-no-gui alone is ~5 GB installer + ~9 GB install). After running `brew bundle`, manually remove unneeded `.pkg` files from the Caskroom directory to reclaim space.
