.DEFAULT_GOAL := help

.PHONY: help deps git-local install setup check

help:
	@printf '%s\n' \
	  'make setup     Install dependencies, prepare local Git config and link dotfiles' \
	  'make deps      Install Git, Zsh, tmux, Vim and unzip' \
	  'make git-local Create personal Git config if missing' \
	  'make install   Prepare personal Git config and link dotfiles' \
	  'make check     Check required tools and shell script syntax'

deps:
	@sh scripts/install-deps.sh

git-local:
	@if [ ! -e git/.gitconfig.local ] && [ ! -L git/.gitconfig.local ]; then \
		cp git/.gitconfig.local.example git/.gitconfig.local; \
		printf '%s\n' 'Created git/.gitconfig.local; edit your name and email before committing.'; \
	fi

install: git-local
	@sh install.sh

setup:
	@$(MAKE) deps
	@$(MAKE) install

check:
	@sh -n install.sh scripts/install-deps.sh
	@missing=0; for tool in git zsh tmux vim unzip; do \
		if command -v "$$tool" >/dev/null 2>&1; then \
			printf 'Available: %s\n' "$$tool"; \
		else printf 'Missing: %s\n' "$$tool"; missing=1; fi; \
	done; exit "$$missing"
