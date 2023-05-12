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
  exa \
  fd-find \
  git \
  ripgrep \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zsh
