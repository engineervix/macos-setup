# =============================================================================
# Brewfile — macOS package manifest
# Usage: brew bundle --file=Brewfile
# =============================================================================

# === Custom taps ===
tap "FelixKratz/formulae"   # JankyBorders + SketchyBar
tap "nikitabobko/tap"       # AeroSpace
tap "mediosz/tap"           # SwipeAeroSpace
tap "hashicorp/tap"         # Terraform

# === Shell ===
brew "zsh"
brew "starship"
brew "zsh-syntax-highlighting"
brew "zsh-autosuggestions"
brew "zsh-completions"

# === GNU coreutils (replace macOS BSD versions) ===
brew "coreutils"         # gls, gdate, etc. — gnubin added to PATH in .zshrc
brew "gnu-sed"           # gsed — gnubin added to PATH in .zshrc

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
brew "bandwhich"         # network monitor (btop alternative for network)
brew "fastfetch"         # system info

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
brew "pinentry-mac"      # GPG pinentry for macOS Keychain
brew "trivy"             # vulnerability scanner

# === Dev utilities ===
brew "cmake"             # build system (required for YouCompleteMe)
brew "just"              # task runner
brew "httpie"            # HTTP client
brew "yq"                # YAML processor
brew "jq"                # JSON processor
brew "tmux"              # for SSH sessions / remote work
brew "vim"               # fallback editor
brew "presenterm"        # terminal slideshow tool
brew "ccusage"           # CLI tool for analyzing Claude Code usage from local JSONL files
brew "ctop"              # Top-like interface for container metrics

# === Languages & runtimes ===
brew "go"
brew "ruby"
brew "cpanminus"          # non-interactive CPAN client (used to bootstrap local::lib)
brew "deno"
brew "pyenv"
# Volta (Node): installed via curl script in 03_tooling.sh
# Rustup:       installed via curl script in 03_tooling.sh

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
brew "hashicorp/tap/terraform"
brew "rclone"

# === Document & PDF processing ===
brew "pandoc"
brew "pdftk-java"
brew "ghostscript"
brew "img2pdf"
brew "ocrmypdf"
brew "tesseract"
brew "unpaper"

# === Image & media ===
brew "imagemagick"
brew "ffmpeg"
brew "mpv"
brew "yt-dlp"
brew "exiftool"

# === Geospatial (GIS) ===
brew "gdal"
brew "proj"

# === Presentation & docs ===
brew "marp-cli"

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
brew "sketchybar"
brew "borders"           # JankyBorders — coloured focus border for active window
cask "swipeaerospace"    # 3-finger trackpad swipe for AeroSpace workspace switching
cask "maccy"             # clipboard manager (complements Spotlight clipboard history)

# === Browsers ===
cask "google-chrome"
cask "brave-browser"
cask "firefox"
cask "ungoogled-chromium"

# === Editors & IDEs ===
brew "neovim"
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
cask "stats"             # menu bar system monitor
cask "aldente"           # battery charge limiter
cask "localsend"         # local network file sharing
cask "tailscale-app"
cask "mullvad-vpn"

# === Creative & media ===
cask "vlc"
cask "spotify"
cask "gimp"
cask "inkscape"
cask "blender"
cask "musescore"

# === R & data science ===
cask "r-app"
cask "rstudio"
cask "mactex-no-gui"

# === Java (required for Android dev) ===
cask "zulu@17"
