#!/bin/sh

# This script sets up all the dotfiles.

# make variable for this dotfiles directory
export DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# update
git pull origin master

# set symbolic links
ln -sfhv "$DOTFILES_DIR/.aliases" ~
ln -sfhv "$DOTFILES_DIR/.bash_profile" ~
ln -sfhv "$DOTFILES_DIR/.bashrc" ~
ln -sfhv "$DOTFILES_DIR/.exports" ~
ln -sfhv "$DOTFILES_DIR/.gitconfig" ~
ln -sfhv "$DOTFILES_DIR/.inputrc" ~
ln -sfhv "$DOTFILES_DIR/.prompt" ~

