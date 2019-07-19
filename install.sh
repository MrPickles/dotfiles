#!/bin/bash

# This is the one-liner installation script for these dotfiles. To install,
# run one of these two commands...
#
# curl andrew.cloud/dotfiles.sh | sh
# or
# wget -qO- andrew.cloud/dotfiles.sh | sh

{ # This ensures the entire script is downloaded.

  basedir=$HOME/.dotfiles
  repourl=https://github.com/MrPickles/dotfiles.git

  if ! command -v git >/dev/null ; then
    echo "Error: Git is not installed!"
    exit 1
  fi

  if [ -d "$basedir/.git" ]; then
    cd "$basedir" || exit
    git pull --quiet --rebase origin master
  else
    rm -rf "$basedir"
    git clone --quiet --depth=1 "$repourl" "$basedir"
  fi

  cd "$basedir" || exit
  . configure.sh -t build

} # This ensures the entire script is downloaded.
