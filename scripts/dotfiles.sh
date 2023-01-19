#!/usr/bin/env bash

# This is the one-liner installation script for these dotfiles. To install,
# run one of these two commands...
#
# curl -L andrew.cloud/dotfiles.sh | sh
# or
# wget -qO- andrew.cloud/dotfiles.sh | sh
# or
# curl https://raw.githubusercontent.com/MrPickles/dotfiles/master/scripts/dotfiles.sh | sh

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
    git clone --quiet --filter=blob:none "$repourl" "$basedir"
  fi

  cd "$basedir" || exit
  # shellcheck source=setup.sh
  . setup.sh -t build

} # This ensures the entire script is downloaded.
