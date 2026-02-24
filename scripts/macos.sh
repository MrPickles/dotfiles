#!/usr/bin/env bash

if [[ $(uname) != "Darwin" ]]; then
  echo "This script should be run on MacOS only."
  exit 1
fi

# Remove hide delay for the dock
# https://apple.stackexchange.com/a/46222
defaults write com.apple.Dock autohide-delay -float 0;killall Dock

if [[ -z "$(command -v brew)" ]]; then
  # Install Homebrew.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
  brew install \
    bat \
    eza \
    fd \
    fzf \
    git-delta \
    jq \
    neovim \
    reattach-to-user-namespace \
    ripgrep \
    tmux \
    tree-sitter-cli \
    zoxide
fi
