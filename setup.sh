#!/usr/bin/env bash

# Configuration script to symlink the dotfiles or clean up the symlinks.
# The script should take a target flag stating whether "build" or "clean". The
# first option will symlink all of the dotfiles and attempt to install
# oh-my-zsh. Otherwise, the script will simply remove all symlinks.

usage="Usage: $0 [-h] [-t <build|clean>]"
BUILD=true
INTERACTIVE=

while getopts :ht: option; do
  case $option in
    h)
      echo "$usage"
      echo
      echo "OPTIONS"
      echo "-h            Output verbose usage message"
      echo "-t build      Set up dotfile symlinks and configure oh-my-zsh"
      echo "-t clean      Remove all existing dotfiles symlinks"
      exit;;
    t)
      INTERACTIVE=true
      if [[ "build" =~ ^${OPTARG} ]]; then
        BUILD=true
      elif [[ "clean" =~ ^${OPTARG} ]]; then
        BUILD=
      else
        echo "$usage" >&2
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
  'editor/coc.vim'

  'git/gitattributes'
  'git/main.gitconfig'
  'git/gitignore'

  'shell/ignore'
  'shell/tmux.conf'
  'shell/zshrc'
  'shell/ripgreprc'
  'shell/p10k.zsh'

  'third_party/Gdbinit/gdbinit'
)

declare -a FULL_PATH_FILES_TO_SYMLINK=(
  'config/nvim/init.vim'
)

print_success() {
  if [[ $BUILD ]]; then
    # Print output in green
    printf "\e[0;32m  [✔] %s\e[0m\n" "$1"
  else
    # Print output in cyan
    printf "\e[0;36m  [✔] Unlinked %s\e[0m\n" "$1"
  fi
}

print_error() {
  if [[ $BUILD ]]; then
    # Print output in red
    printf "\e[0;31m  [✖] %s %s\e[0m\n" "$1" "$2"
  else
    # Print output in red
    printf "\e[0;31m  [✖] Failed to unlink %s %s\e[0m\n" "$1" "$2"
  fi
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] %s\e[0m" "$1"
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

print_result() {
  if [ "$1" -eq 0 ]; then
    print_success "$2"
  else
    print_error "$2"
  fi

  [ "$3" == "true" ] && [ "$1" -ne 0 ] && exit
}

ask_for_confirmation() {
  print_question "$1 [y/N] "
  read -r -n 1
  printf "\n"
}

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

install_zsh() {
  # Test to see if zsh is installed.
  if [ -z "$(command -v zsh)" ]; then
    # If zsh isn't installed, get the platform of the current machine and
    # install zsh with the appropriate package manager.
    platform=$(uname);
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get -y install zsh
      fi
    elif [[ $platform == 'Darwin' ]]; then
      brew install zsh
    fi
  fi
  # Set the default shell to zsh if it isn't currently set to zsh
  if [[ ! "$SHELL" == "$(command -v zsh)" ]]; then
    sudo chsh -s "$(command -v zsh)"
  fi
}

install_zsh_extras() {
  # Clone Oh My Zsh if it isn't already present
  if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
    git clone --filter=blob:none https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
  fi
  # Clone Powerlevel10k if it isn't already present.
  if [[ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    git clone --filter=blob:none \
      --branch v1.15.0 \
      https://github.com/romkatv/powerlevel10k.git \
      "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  fi
  if [[ ! -d $HOME/.oh-my-zsh/custom/plugins/fzf-tab ]]; then
    git clone --filter=blob:none \
      https://github.com/Aloxaf/fzf-tab \
      ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
  fi
}

install_optional_extras() {
  platform=$(uname);
  if [[ $platform == 'Darwin' ]]; then
    brew install ripgrep fd exa bat git-delta neovim
  elif [[ $platform == 'Linux' ]]; then
    if [[ -f /etc/debian_version ]]; then
      # https://askubuntu.com/a/1300824
      sudo apt-get -y -o Dpkg::Options::="--force-overwrite" install ripgrep bat fd-find neovim
      echo "Please install exa and git-delta yourself."
    else
      echo "Unsupported OS. Install extras yourself... ¯\_(ツ)_/¯"
    fi
  fi
}

link_file() {
  local sourceFile=$1
  local targetFile=$2

  if [ ! -e "$targetFile" ]; then
    execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
  elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
    print_success "$targetFile → $sourceFile"
  elif [[ $INTERACTIVE ]]; then
    ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
    if answer_is_yes; then
      rm -rf "$targetFile"
      execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    else
      print_error "$targetFile → $sourceFile"
    fi
  else
    # This this isn't interactive, create a backup of the original file.
    execute "cp $targetFile $targetFile.bak" "$targetFile → $targetFile.bak"
    execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
  fi
}

unlink_file() {
  local sourceFile=$1
  local targetFile=$2

  if [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
    execute "unlink $targetFile" "$targetFile"
  fi
}

# Symlink (or unlink) the dotfiles.
for i in "${FILES_TO_SYMLINK[@]}"; do
  sourceFile="$(pwd)/$i"
  targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

  if [[ $BUILD ]]; then
    link_file $sourceFile $targetFile
  else
    unlink_file $sourceFile $targetFile
  fi
done

for i in "${FULL_PATH_FILES_TO_SYMLINK[@]}"; do
  sourceFile="$(pwd)/$i"
  targetFile="$HOME/.$i"

  if [[ $BUILD ]]; then
    mkdir -p $(dirname $targetFile)
    link_file $sourceFile $targetFile
  else
    unlink_file $sourceFile $targetFile
  fi
done

if [[ $BUILD ]]; then
  # Install zsh (if not available) and oh-my-zsh and p10k.
  install_zsh
  install_zsh_extras
  install_optional_extras

  # Link gitconfig.
  git config --global include.path ~/.main.gitconfig
fi
