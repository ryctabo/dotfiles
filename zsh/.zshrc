# @author ryctabo
# ZSH configuration file

# Oh-my-zsh configuration, more detail in -> http://ohmyz.sh/
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Oh-my-zsh theme, for more information go to the following link:
# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="half-life"
DEFAULT_USER="$USER"

# Oh-my-zsh plugin, E.g. plugins(git brew ruby rails)
plugins=(git)

# Source Oh-my-zsh :3
if [ -r "$ZSH/oh-my-zsh.sh" ]; then
	source "$ZSH/oh-my-zsh.sh"
fi
if [ -r "$HOME/.profile" ]; then
	source ~/.profile
fi

# Prefer FNM; fall back to the system NVM installation.
if command -v fnm >/dev/null 2>&1; then
	eval "$(fnm env --use-on-cd --shell zsh)"
elif [ -r /usr/share/nvm/init-nvm.sh ]; then
	source /usr/share/nvm/init-nvm.sh
fi

# User configuration
# Language environment
export LANG=en_US.UTF-8

# Preferred editor 
export EDITOR='vim'

# Set up PATH environment
typeset -U path PATH
# Enable maven
if [[ -n "$MVN_HOME" && -d "$MVN_HOME/bin" ]]; then
	PATH="$PATH:$MVN_HOME/bin";
fi

# Enable gradle
if [[ -n "$GRADLE_HOME" && -d "$GRADLE_HOME/bin" ]]; then
	PATH="$PATH:$GRADLE_HOME/bin";
fi

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $CURRENT_FG '%c'
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
	if [[ $(id -u) -ne 0 ]]; then
		prompt_segment black default "✪"
	else
		prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
	fi
}

# Bun completions
[ -s "/home/ryctabo/.bun/_bun" ] && source "/home/ryctabo/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> Codex installer >>>
export PATH="/home/ryctabo/.local/bin:$PATH"
# <<< Codex installer <<<
