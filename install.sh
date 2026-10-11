#!/bin/sh
# Install symlinks and back up existing configurations.
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
backup_dir=

for entry in tmux/.tmux.conf zsh/.zshrc git/.gitconfig; do
    source_path="$repo_dir/$entry"
    target_path="$HOME/${entry##*/}"
    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
        printf 'Already installed: %s\n' "$target_path"
        continue
    fi
    # Keep conflicting files in a single backup directory per run.
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        if [ -z "$backup_dir" ]; then
            backup_dir=$(mktemp -d "$HOME/.dotfiles-backup.XXXXXX")
            printf 'Backup directory: %s\n' "$backup_dir"
        fi
        mv -- "$target_path" "$backup_dir/"
    fi
    ln -s -- "$source_path" "$target_path"
    printf 'Installed: %s\n' "$target_path"
done
