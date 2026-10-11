#!/bin/sh
# Check the environment and collect errors without changing configurations.
set -u

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
failures=0
warnings=0
ok() { printf '[OK] %s\n' "$*"; }
fail() { printf '[FAIL] %s\n' "$*"; failures=$((failures + 1)); }
warn() { printf '[WARN] %s\n' "$*"; warnings=$((warnings + 1)); }
has() { command -v "$1" >/dev/null 2>&1; }

for tool in git zsh tmux vim unzip tar; do
    if has "$tool"; then ok "Tool: $tool";
    else fail "Missing $tool. Run make deps (install tar separately if missing)."; fi
done

# Verify that installed symlinks point to this repository.
for entry in zsh/.zshrc tmux/.tmux.conf git/.gitconfig; do
    target="$HOME/${entry##*/}"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$repo_dir/$entry" ] && [ -r "$target" ]; then
        ok "Link: $target"
    else
        fail "Incorrect, missing or broken link: $target. Run make install."
    fi
done

for file in install.sh scripts/install-deps.sh scripts/check.sh; do
    if sh -n "$repo_dir/$file"; then ok "Shell syntax: $file";
    else fail "Invalid shell syntax: $file"; fi
done

if has zsh; then
    for file in zsh/.zshrc system/.env system/.alias system/.functions; do
        if zsh -f -n "$repo_dir/$file"; then ok "Zsh syntax: $file";
        else fail "Invalid Zsh syntax: $file"; fi
    done
    # Load shared files without running personal Zsh startup scripts.
    if zsh -f -c '
        source "$1/system/.env" || exit
        source "$1/system/.alias" || exit
        source "$1/system/.functions" || exit
        (( $+functions[mk] && $+functions[extract] )) || exit 1
        alias l >/dev/null && command -v "$EDITOR" >/dev/null
    ' check "$repo_dir"; then
        ok 'Shared Zsh configuration loads; functions, alias and editor available'
    else fail 'Shared Zsh configuration failed to load or editor is unavailable'; fi
fi

# Validate Git configuration and identity without printing personal data.
if has git; then
    if git config --file "$repo_dir/git/.gitconfig" --includes --list >/dev/null; then
        ok 'Git configuration syntax (including local configuration)'
        local_config=$(git config --file "$repo_dir/git/.gitconfig" --get include.path) || local_config=
        case "$local_config" in '~/'*) local_config="$HOME/${local_config#\~/}" ;; esac
        if [ -r "$local_config" ]; then
            for key in user.name user.email; do
                value=$(git config --file "$repo_dir/git/.gitconfig" --includes --get "$key") || value=
                case "$value" in
                    ''|'Your Name'|'you@example.com') fail "Set $key in git/.gitconfig.local before committing." ;;
                    *) ok "Git $key is configured" ;;
                esac
            done
        else fail 'Personal Git configuration is missing. Run make git-local and set your name/email.'; fi
    else fail 'Invalid Git configuration; check git/.gitconfig and its includes'; fi
fi

# Test tmux in a temporary server and clean it up on exit.
if has tmux; then
    tmux_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-check.XXXXXX") || exit 1
    cleanup() {
        tmux -S "$tmux_dir/socket" kill-server >/dev/null 2>&1 || :
        rm -f "$tmux_dir/socket" "$tmux_dir/output"
        rmdir "$tmux_dir" 2>/dev/null || :
    }
    trap cleanup EXIT
    trap 'exit 1' HUP INT TERM
    if tmux -S "$tmux_dir/socket" -f /dev/null new-session -d -s dotfiles-check 'sleep 30' >"$tmux_dir/output" 2>&1 &&
       tmux -S "$tmux_dir/socket" source-file "$repo_dir/tmux/.tmux.conf" >>"$tmux_dir/output" 2>&1 &&
       [ ! -s "$tmux_dir/output" ]; then
        ok 'tmux configuration loads in an isolated server'
    else
        fail 'tmux configuration could not load in an isolated server'
        cat "$tmux_dir/output"
    fi
fi

# Missing optional tools produce warnings, not errors.
if [ -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then ok 'Oh My Zsh available';
else warn 'Oh My Zsh absent; configured theme and plugins will not load'; fi
for tool in fnm bun mvn gradle; do
    if has "$tool"; then ok "Optional tool: $tool";
    else warn "Optional tool unavailable: $tool"; fi
done
if ! has fnm && [ -r /usr/share/nvm/init-nvm.sh ]; then ok 'System NVM fallback available'; fi

printf '\nCheck finished: %s failure(s), %s warning(s).\n' "$failures" "$warnings"
[ "$failures" -eq 0 ]
