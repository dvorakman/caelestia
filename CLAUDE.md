# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **caelestia dotfiles** repository containing configuration files for various applications in a Hyprland desktop environment. This repo works in conjunction with:
- [caelestia-shell](https://github.com/caelestia-dots/shell) - Quickshell-based desktop shell
- [caelestia-cli](https://github.com/caelestia-dots/cli) - CLI utilities for theme/wallpaper management

## Installation & Setup

### Fresh Installation

**CRITICAL:** The install script symlinks configs to `~/.config/`. Do NOT move/remove this repo after installation.

Recommended location: `~/.local/share/caelestia`

```bash
git clone https://github.com/dvorakman/caelestia.git ~/.local/share/caelestia
cd ~/.local/share/caelestia
./install.fish
```

**Install script options:**
```bash
./install.fish --help
  --noconfirm                 # Skip confirmation prompts
  --spotify                   # Install Spicetify config
  --vscode=[codium|code]      # Install VSCode/VSCodium config
  --discord                   # Install Discord config
  --zen                       # Install Zen browser config
  --virt-manager              # Install virt-manager and virtualization stack
  --aur-helper=[yay|paru]     # Specify AUR helper
```

### Manual Installation

Install dependencies (or `caelestia-meta` on Arch), then symlink config directories:
```bash
ln -s ~/.local/share/caelestia/hypr ~/.config/hypr
ln -s ~/.local/share/caelestia/fish ~/.config/fish
ln -s ~/.local/share/caelestia/foot ~/.config/foot
ln -s ~/.local/share/caelestia/btop ~/.config/btop
ln -s ~/.local/share/caelestia/fastfetch ~/.config/fastfetch
ln -s ~/.local/share/caelestia/uwsm ~/.config/uwsm
cp ~/.local/share/caelestia/starship.toml ~/.config/starship.toml
```

## Repository Structure

**Config Directories (symlinked to ~/.config/):**
- `hypr/` - Hyprland window manager configuration
- `fish/` - Fish shell configuration
- `foot/` - Foot terminal configuration
- `btop/` - System monitor configuration
- `fastfetch/` - System info tool configuration
- `thunar/` - File manager configuration
- `uwsm/` - Universal Wayland Session Manager
- `starship.toml` - Shell prompt configuration

**Optional App Configs:**
- `spicetify/` - Spotify theming
- `vscode/` - VSCode/VSCodium settings
- `zen/` - Zen browser userChrome and native messaging
- `firefox/` - Firefox userChrome
- `zed/` - Zed editor configuration
- `micro/` - Micro text editor configuration

**Installation:**
- `install.fish` - Main installation script (Fish shell)
- `PKGBUILD` - Arch package build script

## Configuration Architecture

### Hyprland Configuration (hypr/)

**Main entry point:** `hyprland.conf`

**Sources modular configs from `hypr/hyprland/`:**
- `env.conf` - Environment variables
- `general.conf` - General window manager settings
- `input.conf` - Input device configuration
- `misc.conf` - Miscellaneous settings
- `animations.conf` - Animation definitions
- `decoration.conf` - Window decorations, blur, shadows
- `group.conf` - Window grouping/tabbing
- `execs.conf` - Auto-start applications
- `rules.conf` - Window rules
- `gestures.conf` - Touchpad gestures
- `keybinds.conf` - Keyboard shortcuts

**User customization pattern:**
- `hypr/variables.conf` - Configurable variables (sourced by hyprland.conf)
- `~/.config/caelestia/hypr-vars.conf` - User variable overrides (auto-created, not tracked)
- `~/.config/caelestia/hypr-user.conf` - User Hyprland config additions (auto-created, not tracked)

**Color scheme:**
- `hypr/scheme/` - Color scheme definitions
- `hypr/scheme/current.conf` - Active scheme (auto-generated from default.conf on startup)

### Fish Shell Configuration (fish/)

**Main config:** `config.fish` - Initializes prompt, tools, and aliases

**Modular configuration via `conf.d/` (auto-loaded):**
- `conf.d/nvm.fish` - Node Version Manager setup
- `conf.d/personal.fish` - Personal customizations (Claude Code, GitHub CLI aliases)

**Functions:** `functions/` - Custom Fish functions and nvm plugin functions

**Completions:** `completions/` - Shell completion scripts

**Plugins:** Managed via `fish_plugins` file (uses Fisher or similar)

**Tool integrations in config.fish:**
- Starship prompt
- direnv (environment management)
- zoxide (smart cd)
- eza (better ls)

### Personal Customizations

**Pattern:** Add personal configs to `fish/conf.d/personal.fish` to keep separate from base config.

Current personal customizations include:
- Claude Code abbreviations (`cc`, `ccs`, `ccd`)
- GitHub CLI shortcuts (`ghpr`, `ghpv`, `ghrw`, etc.)
- Git + GitHub workflows (`gpc`, `gpv`)

## Key Configuration Patterns

### User Override System

Caelestia uses non-tracked user config files for personal overrides:

**Hyprland:**
- Edit `~/.config/caelestia/hypr-user.conf` for custom Hyprland settings
- Edit `~/.config/caelestia/hypr-vars.conf` for variable overrides

**Shell:**
- Color sequences loaded from `~/.local/state/caelestia/sequences.txt` (managed by caelestia-cli)

### Fish Shell Abbreviations

The config defines many git abbreviations:
- `ga` → `git add .`
- `gc` → `git commit -am`
- `gp` → `git push`
- `gsw` → `git switch`
- `gsm` → `git switch main`

Plus personal abbreviations in `conf.d/personal.fish`.

### Application-Specific Setup

**Spicetify (Spotify):**
```bash
spicetify config current_theme caelestia color_scheme caelestia custom_apps marketplace
spicetify apply
```

**VSCode/VSCodium:**
- Symlink settings/keybindings to `~/.config/Code/User/` or `~/.config/VSCodium/User/`
- Install extension: `code --install-extension vscode/caelestia-vscode-integration/*.vsix`

**Zen Browser:**
- Symlink `userChrome.css` to `~/.zen/<profile>/chrome/`
- Install native app for theme integration

## Maintenance

### Updating

**For forked repo (personal setup):**
```bash
cd ~/.local/share/caelestia
git fetch upstream
git merge upstream/main
```

**For upstream install:**
```bash
cd ~/.local/share/caelestia
git pull
```

### Symlink Management

All configs are symlinked, so edits in `~/.config/` directories directly modify the git repo. Be careful when committing changes.

To verify symlinks:
```bash
ls -la ~/.config/hypr  # Should point to ~/.local/share/caelestia/hypr
ls -la ~/.config/fish  # Should point to ~/.local/share/caelestia/fish
```

## Integration with Caelestia Ecosystem

This dotfiles repo works with:
- **caelestia-shell** - Desktop shell (installed separately to `/etc/xdg/quickshell/caelestia` or `~/.config/quickshell/caelestia`)
- **caelestia-cli** - Commands for theme/wallpaper management (`caelestia scheme`, `caelestia wallpaper`, etc.)

Shell config auto-loads if installed via the `install.fish` script through `hypr/hyprland/execs.conf`.

## Key Hyprland Keybinds

Understanding these keybinds is essential when working with or testing the configuration:

- `Super` - Open launcher
- `Super` + `#` - Switch to workspace `#`
- `Super` `Alt` + `#` - Move window to workspace `#`
- `Super` + `T` - Open terminal (foot)
- `Super` + `W` - Open browser (zen)
- `Super` + `C` - Open IDE (vscodium)
- `Super` + `S` - Toggle special workspace or close current special workspace
- `Ctrl` `Alt` + `Delete` - Open session menu
- `Ctrl` `Super` + `Space` - Toggle media play state
- `Ctrl` `Super` `Alt` + `R` - Restart the shell

All keybinds are defined in `hypr/hyprland/keybinds.conf`.

## Important Notes

**Login Manager:** These dotfiles do not include a login manager. The system assumes a login manager (like greetd/tuigreet) is already configured, or the user logs in from a TTY.

**Symlink Architecture:** Since all configs are symlinked, editing files in `~/.config/` directories directly modifies the git repository. This is by design but requires care when committing changes.
