# @author ryctabo
# ZSH configuration file

# Oh-my-zsh configuration, more detail in -> http://ohmyz.sh/
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Oh-my-zsh theme, for more information go to the following link:
# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
DEFAULT_USER="$USER"

# Oh-my-zsh plugin, E.g. plugins(git brew ruby rails)
plugins=(git)
# Source Oh-my-zsh :3
source $ZSH/oh-my-zsh.sh
source ~/.profile

# Source NVM
if [ -d /usr/share/nvm ]; then
	source /usr/share/nvm/init-nvm.sh
fi

# User configuration
# Language environment
export LANG=en_US.UTF-8

# Preferred editor 
export EDITOR='vim'

# Set up PATH environment
# Enable maven
if [ -d $MVN_HOME/bin ]; then
	PATH="$PATH:$MVN_HOME/bin";
fi
# Enable gradle
if [ -d $GRADLE_HOME/bin ]; then
	PATH="$PATH:$GRADLE_HOME/bin";
fi
# Enable NPM
if [ -d $HOME/.npm/bin ]; then
	PATH="$PATH:$HOME/.npm/bin";
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

