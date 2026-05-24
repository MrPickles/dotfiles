#!/usr/bin/env bash
set -euo pipefail

brew_bin=""

if [[ $(uname -s) != "Darwin" ]]; then
  echo "This script should be run on macOS only." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
  brew_bin=$(command -v brew)
  eval "$("${brew_bin}" shellenv)"
else
  echo "Unable to find Homebrew after installation." >&2
  exit 1
fi
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
