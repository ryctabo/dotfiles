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

