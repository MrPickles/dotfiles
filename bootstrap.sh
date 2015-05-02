#!/bin/sh

export DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git pull origin master

ln -sfhv "$DOTFILES_DIR/.aliases" ~
ln -sfhv "$DOTFILES_DIR/.bash_profile" ~
ln -sfhv "$DOTFILES_DIR/.bashrc" ~
ln -sfhv "$DOTFILES_DIR/.exports" ~
ln -sfhv "$DOTFILES_DIR/.gitconfig" ~
ln -sfhv "$DOTFILES_DIR/.inputrc" ~
ln -sfhv "$DOTFILES_DIR/.prompt" ~

