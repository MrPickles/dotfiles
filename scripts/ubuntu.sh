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
  git \
  gpg \
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
  wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  chmod +x nvim.appimage
  ./nvim.appimage --appimage-extract
  sudo mv squashfs-root /
  sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
  rm nvim.appimage
fi

if ! _has delta; then
  wget https://github.com/dandavison/delta/releases/download/0.15.1/git-delta-musl_0.15.1_amd64.deb
  sudo dpkg -i git-delta-musl_0.15.1_amd64.deb
  rm git-delta-musl_0.15.1_amd64.deb
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
