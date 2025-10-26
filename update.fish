#!/usr/bin/env fish

# update.fish - Update caelestia forks from upstream and rebuild packages

argparse -n 'update.fish' -X 0 \
    'h/help' \
    'noconfirm' \
    'no-rebuild' \
    'restart-shell' \
    'upstream-only' \
    -- $argv
or exit

# Print help
if set -q _flag_h
    echo 'usage: ./update.fish [-h] [--noconfirm] [--no-rebuild] [--restart-shell] [--upstream-only]'
    echo
    echo 'Update caelestia personal forks from upstream and rebuild packages'
    echo
    echo 'options:'
    echo '  -h, --help          show this help message and exit'
    echo '  --noconfirm         do not confirm package installation or updates'
    echo '  --no-rebuild        fetch/merge upstream but do not rebuild packages'
    echo '  --restart-shell     restart quickshell after updates'
    echo '  --upstream-only     only sync from upstream, skip pulling from origin'
    exit
end

# Helper functions
function _out -a colour text
    set_color $colour
    echo $argv[3..] -- ":: $text"
    set_color normal
end

function log -a text
    _out cyan $text $argv[2..]
end

function warn -a text
    _out yellow $text $argv[2..]
end

function error -a text
    _out red $text $argv[2..]
end

function success -a text
    _out green $text $argv[2..]
end

function input -a text
    _out blue $text $argv[2..]
end

function sh-read
    set -l result (read)
    echo $result
end

# Configuration
set -l fork_user 'dvorakman'
set -l upstream_user 'caelestia-dots'
set -l cli_path $HOME/.local/share/caelestia-cli
set -l shell_path $HOME/.config/quickshell/caelestia
set -l dotfiles_path $HOME/.local/share/caelestia

set -l noconfirm ''
if set -q _flag_noconfirm
    set noconfirm '--noconfirm'
end

# Track what changed
set -l updated_repos
set -l rebuilt_packages

# Update a repository from upstream
function update_repo -a name path
    if not test -d $path/.git
        error "$name not found at $path"
        return 1
    end

    log "Updating $name..."

    # Get current commit and branch
    set -l before_commit (git -C $path rev-parse HEAD)
    set -l current_branch (git -C $path branch --show-current)

    # Step 1: Pull from origin (your fork) unless upstream-only mode
    if not set -q _flag_upstream_only
        # Fetch from origin (your fork)
        log "Fetching from origin..."
        if not git -C $path fetch origin
            warn "Failed to fetch from origin"
        else
            # Check if origin is ahead of local
            set -l origin_commit (git -C $path rev-parse origin/$current_branch 2>/dev/null)
            if test -n "$origin_commit" -a "$before_commit" != "$origin_commit"
                # Check if we can fast-forward
                set -l merge_base (git -C $path merge-base HEAD origin/$current_branch)
                if test "$merge_base" = "$before_commit"
                    log "Pulling changes from your fork (origin/$current_branch)..."
                    if git -C $path merge origin/$current_branch --ff-only
                        success "Fast-forwarded from origin"
                        set before_commit (git -C $path rev-parse HEAD)
                    else
                        warn "Cannot fast-forward from origin, you may have diverged"
                    end
                else
                    warn "Local branch has diverged from origin, skipping origin merge"
                    log "Run 'git -C $path status' to see divergence"
                end
            end
        end
    end

    # Step 2: Fetch from upstream
    log "Fetching from upstream..."
    if not git -C $path fetch upstream
        error "Failed to fetch from upstream"
        return 1
    end

    # Check if there are upstream changes
    set -l upstream_commit (git -C $path rev-parse upstream/$current_branch)

    if test "$before_commit" = "$upstream_commit"
        success "$name is already up to date with upstream"
        return 0
    end

    # Show what will change
    log "Changes from upstream:"
    git -C $path log --oneline --graph $before_commit..upstream/$current_branch | head -10

    # Ask to merge
    if not set -q _flag_noconfirm
        input "Merge upstream changes into $name? [Y/n] " -n
        set -l response (sh-read)
        if test "$response" = 'n' -o "$response" = 'N'
            warn "Skipping $name"
            return 0
        end
    end

    # Merge upstream
    log "Merging upstream/$current_branch..."
    if not git -C $path merge upstream/$current_branch --no-edit
        error "Merge failed! Please resolve conflicts manually in $path"
        return 1
    end

    set -l after_commit (git -C $path rev-parse HEAD)

    if test "$before_commit" != "$after_commit"
        success "$name updated successfully"
        set -a updated_repos $name
        return 0
    else
        success "$name is up to date"
        return 0
    end
end

# Rebuild package
function rebuild_package -a name path pkgname
    log "Rebuilding $pkgname..."

    set -l current_dir (pwd)
    cd $path

    if makepkg -si $noconfirm -p PKGBUILD
        success "$pkgname rebuilt and installed"
        set -a rebuilt_packages $pkgname
        cd $current_dir
        return 0
    else
        error "Failed to rebuild $pkgname"
        cd $current_dir
        return 1
    end
end

# Main update flow
log "Starting caelestia fork update..."
echo

# Update CLI
if update_repo "CLI" $cli_path
    if not set -q _flag_no_rebuild
        if contains "CLI" $updated_repos
            rebuild_package "CLI" $cli_path "caelestia-cli-personal"
        end
    end
end

echo

# Update Shell
if update_repo "Shell" $shell_path
    if not set -q _flag_no_rebuild
        if contains "Shell" $updated_repos
            rebuild_package "Shell" $shell_path "caelestia-shell-personal"
        end
    end
end

echo

# Update Dotfiles
if update_repo "Dotfiles" $dotfiles_path
    # Dotfiles don't need rebuilding, but metapackage might
    if not set -q _flag_no_rebuild
        if contains "Dotfiles" $updated_repos
            log "Checking if metapackage needs rebuilding..."
            set -l current_dir (pwd)
            cd $dotfiles_path

            # Check if PKGBUILD changed
            if git diff HEAD@{1} HEAD -- PKGBUILD | grep -q '^[+-]'
                warn "PKGBUILD changed, consider rebuilding metapackage"
                if not set -q _flag_noconfirm
                    input "Rebuild caelestia-meta? [y/N] " -n
                    set -l response (sh-read)
                    if test "$response" = 'y' -o "$response" = 'Y'
                        makepkg -si $noconfirm
                        set -a rebuilt_packages "caelestia-meta"
                    end
                end
            end

            cd $current_dir
        end
    end
end

echo

# Summary
if test (count $updated_repos) -gt 0
    success "Updated repositories: "(string join ", " $updated_repos)
else
    log "No repositories were updated"
end

if test (count $rebuilt_packages) -gt 0
    success "Rebuilt packages: "(string join ", " $rebuilt_packages)
end

# Restart shell if requested
if set -q _flag_restart_shell
    if contains "caelestia-shell-personal" $rebuilt_packages
        log "Restarting quickshell..."
        qs -c caelestia kill && sleep 2 && caelestia shell -d
        success "Quickshell restarted"
    else
        warn "Shell not rebuilt, skipping restart"
    end
end

success "Update complete!"
