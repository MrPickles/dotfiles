#!/bin/bash

{ # This ensures the entire script is downloaded.

  set -e

  basedir=$HOME/.dotfiles
  repourl=git://github.com/MrPickles/dotfiles.git

  if ! which git >/dev/null ; then
    echo "Error: Git is not installed!"
    exit 1
  fi

  if [ -d $basedir/.git ]; then
    cd $basedir
    git pull --quiet --rebase origin master
  else
    rm -rf $basedir
    git clone --quiet --depth=1 $repourl $basedir
  fi

  cd $basedir
  . configure.sh -t build

} # This ensures the entire script is downloaded.
