#!/bin/sh
# Install basic tools using the available package manager.
set -eu

# Prefer Homebrew; it does not require sudo.
if command -v brew >/dev/null 2>&1; then
    exec brew install git zsh tmux vim unzip
fi

if command -v apt-get >/dev/null 2>&1; then
    manager=apt-get
elif command -v dnf >/dev/null 2>&1; then
    manager=dnf
elif command -v pacman >/dev/null 2>&1; then
    manager=pacman
else
    printf '%s\n' 'Unsupported package manager. Install git, zsh, tmux, vim and unzip manually.' >&2
    exit 1
fi

# System package managers require root or sudo.
run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        printf '%s\n' 'System package installation requires root or sudo.' >&2
        exit 1
    fi
}

case "$manager" in
    apt-get)
        run_as_root apt-get update
        run_as_root apt-get install -y git zsh tmux vim unzip
        ;;
    dnf) run_as_root dnf install -y git zsh tmux vim unzip ;;
    pacman) run_as_root pacman -S --needed --noconfirm git zsh tmux vim unzip ;;
esac
