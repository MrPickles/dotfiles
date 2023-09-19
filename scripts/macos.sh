#!/usr/bin/env bash

# Remove hide delay for the dock
# https://apple.stackexchange.com/a/46222
defaults write com.apple.Dock autohide-delay -float 0; killall Dock


if [[ -z "$(command -v brew)" ]]; then
  # Install Homebrew.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
  brew install \
    bat \
    eza \
    fd \
    git-delta \
    jq \
    neovim \
    reattach-to-user-namespace \
    ripgrep \
    tmux
fi
