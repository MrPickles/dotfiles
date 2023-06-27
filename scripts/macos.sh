#!/usr/bin/env bash

# Remove hide delay for the dock
# https://apple.stackexchange.com/a/46222
defaults write com.apple.Dock autohide-delay -float 0; killall Dock


if [[ -z "$(command -v brew)" ]]; then
  # Install Homebrew.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
  brew install ripgrep fd exa bat git-delta neovim reattach-to-user-namespace jq tmux
fi
