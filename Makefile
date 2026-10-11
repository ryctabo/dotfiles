.DEFAULT_GOAL := help

.PHONY: help deps git-local install setup check

help:
	@printf '%s\n' \
	  'make setup     Install dependencies, prepare local Git config and link dotfiles' \
	  'make deps      Install Git, Zsh, tmux, Vim and unzip' \
	  'make git-local Create personal Git config if missing' \
	  'make install   Prepare personal Git config and link dotfiles' \
	  'make check     Check installed links, tools and configurations'

deps:
	@sh scripts/install-deps.sh

# Preserve existing personal configuration.
git-local:
	@if [ ! -e git/.gitconfig.local ] && [ ! -L git/.gitconfig.local ]; then \
		cp git/.gitconfig.local.example git/.gitconfig.local; \
		printf '%s\n' 'Created git/.gitconfig.local; edit your name and email before committing.'; \
	fi

install: git-local
	@sh install.sh

# Install dependencies first, even with make -j.
setup:
	@$(MAKE) deps
	@$(MAKE) install

check:
	@sh scripts/check.sh
