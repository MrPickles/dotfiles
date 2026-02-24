#!/usr/bin/env bash

# This script installs most relevant packages for Ubuntu 22.04.
_has() {
  # shellcheck disable=SC2046 # Quoting everything gives the wrong semantics.
  return $(which "$1" >/dev/null)
}

sudo apt install -y \
  bat \
  build-essential \
  curl \
  fd-find \
  fzf \
  git \
  gpg \
  jq \
  mosh \
  ripgrep \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zsh

if ! _has nvim; then
  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
  chmod +x nvim-linux-x86_64.appimage
  ./nvim-linux-x86_64.appimage --appimage-extract
  sudo mv squashfs-root /
  sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
  rm nvim-linux-x86_64.appimage
fi

if ! _has delta; then
  DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq -r .tag_name)
  wget "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta-musl_${DELTA_VERSION}_amd64.deb"
  sudo dpkg -i "git-delta-musl_${DELTA_VERSION}_amd64.deb"
  rm "git-delta-musl_${DELTA_VERSION}_amd64.deb"
fi

if ! _has eza; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
fi

if ! _has fd; then
  mkdir -p ~/.local/bin
  ln -s "$(which fdfind)" ~/.local/bin/fd
fi

if ! _has zoxide; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

if ! _has tree-sitter; then
  wget "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
  gzip -d tree-sitter-linux-x64.gz
  chmod +x tree-sitter-linux-x64
  sudo mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter
fi
