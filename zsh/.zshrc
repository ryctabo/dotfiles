# @author ryctabo
# ZSH configuration file

# Oh-my-zsh configuration, more detail in -> http://ohmyz.sh/
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="half-life"
DEFAULT_USER="$USER"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

# Language environment
export LANG=en_US.UTF-8

# Load shared configuration relative to this file's resolved location.
for dotfiles_config in "${${(%):-%x}:A:h:h}"/system/.env \
                       "${${(%):-%x}:A:h:h}"/system/.alias \
                       "${${(%):-%x}:A:h:h}"/system/.functions; do
	if [ -r "$dotfiles_config" ]; then
		source "$dotfiles_config"
	fi
done
unset dotfiles_config

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
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> Codex installer >>>
export PATH="$HOME/.local/bin:$PATH"
# <<< Codex installer <<<

# opencode
export PATH=/home/ryctabo/.opencode/bin:$PATH
