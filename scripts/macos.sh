#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -s) != "Darwin" ]]; then
  echo "This script should be run on macOS only." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
hash -r

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

# Remove hide delay for the dock.
# https://apple.stackexchange.com/a/46222
defaults write com.apple.Dock autohide-delay -float 0
killall Dock
