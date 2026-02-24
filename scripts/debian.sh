#!/usr/bin/env bash

# Debian only (not Ubuntu). Recommended for beefy machines because Cargo can't run on a toaster.

# Install APT binaries.
sudo apt install -y \
  build-essential \
  curl \
  fzf \
  git \
  gpg \
  mosh \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zsh

# Install Cargo (non-interactively).
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install Rust binaries.
cargo install \
  bat \
  eza \
  fd-find \
  git-delta \
  ripgrep \
  tree-sitter-cli \
  zoxide

# Install Neovim.
tmpdir=$(mktemp -d)
mkdir -p "$tmpdir"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz --output-dir "$tmpdir"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf "${tmpdir}/nvim-linux64.tar.gz"
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/nvim
rm -rf "$tmpdir"
