#!/usr/bin/env bash

# This script installs most relevant packages for Ubuntu 22.04.
#
# TODO: Eventually, it might be good to add a few extras:
# - Installing git-delta
# - Installing neovim
# - Properly linking fd-find
# Most of these can be copied from the Dockerfile.

sudo apt install \
  bat \
  build-essential \
  curl \
  fd-find \
  git \
  gpg \
  ripgrep \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zsh

sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
