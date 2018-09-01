#!/bin/bash

# Configuration script to symlink the dotfiles or clean up the symlinks.
# The script should take a target flag stating whether "build" or "clean". The
# first option will symlink all of the dotfiles and attempt to install
# oh-my-zsh. Otherwise, the script will simply remove all symlinks.

usage="Usage: $0 [-h] [-t <build|clean>]"

if [[ "$#" -lt 1 ]]; then
  echo $usage
  exit
fi

while getopts :ht: option; do
  case $option in
    h)
      echo $usage
      echo
      echo "OPTIONS"
      echo "-h            Output verbose usage message"
      echo "-t build      Set up dotfile symlinks and configure oh-my-zsh"
      echo "-t clean      Remove all existing dotfiles symlinks"
      exit;;
    t)
      if [[ "build" =~ ^${OPTARG} ]]; then
        BUILD=true
      elif [[ "clean" =~ ^${OPTARG} ]]; then
        BUILD=
      else
        echo $usage >&2
        exit 1
      fi;;
    \?)
      echo "Unknown option: -$OPTARG" >&2
      exit 1;;
    :)
      echo "Missing argument for -$OPTARG" >&2
      exit 1;;
  esac
done

declare -a FILES_TO_SYMLINK=(
  'editor/vim'
  'editor/vimrc'

  'git/gitattributes'
  'git/gitconfig.static'
  'git/gitignore'

  'shell/dircolors.256dark'
  'shell/gdbinit'
  'shell/tmux.conf'
  'shell/zshrc'

  'third_party/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh'
)

print_success() {
  if [[ $BUILD ]]; then
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
  else
    # Print output in cyan
    printf "\e[0;36m  [✔] Unlinked $1\e[0m\n"
  fi
}

print_error() {
  if [[ $BUILD ]]; then
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
  else
    # Print output in red
    printf "\e[0;31m  [✖] Failed to unlink $1 $2\e[0m\n"
  fi
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] $1\e[0m"
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

print_result() {
  [ $1 -eq 0 ] \
    && print_success "$2" \
    || print_error "$2"

  [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}

ask_for_confirmation() {
  print_question "$1 [y/N] "
  read -n 1
  printf "\n"
}

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

install_zsh() {
  # Test to see if zshell is installed.
  if [ -z $(which zsh) ]; then
    # If zsh isn't installed, get the platform of the current machine and
    # install zsh with the appropriate package manager.
    platform=$(uname);
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get install zsh
      fi
    elif [[ $platform == 'Darwin' ]]; then
      brew install zsh
    fi
  fi
  # Set the default shell to zsh if it isn't currently set to zsh
  if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
    chsh -s $(which zsh)
  fi
  # Clone Oh My Zsh if it isn't already present
  if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
  fi
}

# Symlink (or unlink) the dotfiles.
for i in ${FILES_TO_SYMLINK[@]}; do
  sourceFile="$(pwd)/$i"
  targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

  if [[ $BUILD ]]; then
    if [ ! -e "$targetFile" ]; then
      execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      print_success "$targetFile → $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
      else
        print_error "$targetFile → $sourceFile"
      fi
    fi
  else
    if [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      execute "unlink $targetFile" "$targetFile"
    fi
  fi
done

sourceFile="$(pwd)/themes/pickles.zsh-theme"
targetFile="$HOME/.oh-my-zsh/custom/pickles.zsh-theme"

if [[ $BUILD ]]; then
  # Prompt to switch to zsh and oh-my-zsh if not active on terminal.
  if [ ! -f /bin/zsh -a ! -f /usr/bin/zsh -o ! -d $HOME/.oh-my-zsh/ ]; then
    ask_for_confirmation "Switch to zsh and oh-my-zsh?"
    if answer_is_yes; then
      install_zsh
    fi
  fi

  # Link custom zsh theme.
  execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"

  # Link static gitignore.
  git config --global include.path ~/.gitconfig.static
else
  # Unlink custom zsh theme.
  execute "unlink $targetFile" "$targetFile"
fi
