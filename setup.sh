#!/usr/bin/env bash

# Configuration script to symlink the dotfiles or clean up the symlinks.
# The script should take a target flag stating whether "build" or "clean". The
# first option will symlink all of the dotfiles and attempt to install
# oh-my-zsh. Otherwise, the script will simply remove all symlinks.

usage="Usage: $0 [-h] [-t <build|clean|shellcheck>]"
BUILD=true
INTERACTIVE=

while getopts :ht: option; do
  case ${option} in
    h)
      echo "${usage}"
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
      elif [[ "shellcheck" =~ ^${OPTARG} ]]; then
        shellcheck -x -- **/*.sh
        exit 0
      else
        echo "${usage}" >&2
        exit 1
      fi;;
    \?)
      echo "Unknown option: -${OPTARG}" >&2
      exit 1;;
    :)
      echo "Missing argument for -${OPTARG}" >&2
      exit 1;;
  esac
done

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
    if [[ $platform == "Linux" ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get -y install zsh
      fi
    elif [[ $platform == "Darwin" ]]; then
      brew install zsh
    fi
  fi
  # Set the default shell to zsh if it isn't currently set to zsh
  if [[ ! "$SHELL" == "$(command -v zsh)" ]]; then
    sudo chsh -s "$(command -v zsh)"
  fi
}

install_zsh_extras() {
  ZSH=${HOME}/.oh-my-zsh
  ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH}/custom}"

  # Clone or update Oh My Zsh.
  if [[ ! -d "${ZSH}" ]]; then
    git clone --quiet --filter=blob:none https://github.com/robbyrussell/oh-my-zsh "${ZSH}"
  else
    git -C "${ZSH}" pull --quiet
  fi

  # Clone or update Powerlevel10k.
  THEME_REPO_URL="https://github.com/romkatv/powerlevel10k"
  THEME_PATH="${ZSH_CUSTOM}/themes/${THEME_REPO_URL##*/}"
  THEME_VERSION_TAG="v1.17.0"
  if [[ ! -d "${THEME_PATH}" ]]; then
    git clone --quiet --filter=blob:none --branch "${THEME_VERSION_TAG}" "${THEME_REPO_URL}" "${THEME_PATH}"
  else
    git -C "${THEME_PATH}" fetch --quiet
    git -C "${THEME_PATH}" checkout "${THEME_VERSION_TAG}" --quiet
  fi

  # Install or update custom oh-my-zsh plugins.
  CUSTOM_PLUGIN_REPOS=(
    "https://github.com/Aloxaf/fzf-tab"
    "https://github.com/zdharma-continuum/fast-syntax-highlighting"
    "https://github.com/zsh-users/zsh-autosuggestions"
  )
  for REPO_URL in "${CUSTOM_PLUGIN_REPOS[@]}"; do
    PLUGIN_PATH="${ZSH_CUSTOM}/plugins/${REPO_URL##*/}"
    if [[ ! -d "${PLUGIN_PATH}" ]]; then
      git clone --quiet --filter=blob:none "${REPO_URL}" "${PLUGIN_PATH}"
    else
      git -C "${PLUGIN_PATH}" pull --quiet
    fi
  done
}

install_optional_extras() {
  platform=$(uname);
  if [[ $platform == "Darwin" ]]; then
    brew install ripgrep fd exa bat git-delta neovim
  elif [[ $platform == "Linux" ]]; then
    if [[ -f /etc/debian_version ]]; then
      sudo apt-get -y install bat exa fd-find ripgrep
      echo "Please install neovim and git-delta yourself."
    else
      echo "Unsupported OS. Install extras yourself... ¯\_(ツ)_/¯"
    fi
  fi
}

link_file() {
  local source=$1
  local target=$2

  if [ ! -e "${target}" ]; then
    # If the target location doesn't exist, we can safely symlink.
    execute "ln -fs ${source} ${target}" "${target} → ${source}"
  elif [ "$(readlink "${target}")" == "${source}" ]; then
    # If the target location is already symlinked, we do nothing.
    print_success "${target} → ${source}"
  elif [[ $INTERACTIVE ]]; then
    # If there's a potential conflict, we prompt before overwriting.
    ask_for_confirmation "'${target}' already exists, do you want to overwrite it?"
    if answer_is_yes; then
      rm -rf "${target}"
      execute "ln -fs ${source} ${target}" "${target} → ${source}"
    else
      print_error "${target} → ${source}"
    fi
  else
    # This this isn't interactive, create a backup of the original file.
    execute "cp ${target} ${target}.bak" "${target} → ${target}.bak"
    execute "ln -fs ${source} ${target}" "${target} → ${source}"
  fi
}

unlink_file() {
  local source=$1
  local target=$2

  if [ "$(readlink "${target}")" == "${source}" ]; then
    execute "unlink ${target}" "${target}"
  fi
}

main() {
  # Run the symlinking from the repo root.
  cd "$(dirname "$0")" || exit

  # Symlink (or unlink) the dotfiles.
  # Technically, this won't work for odd filenames, e.g. those with spaces or
  # newlines. However, we don't care in this case and would rather have broader
  # compatibility.
  #
  # shellcheck disable=SC2207
  FILES_TO_SYMLINK=($(find home -type f))
  for dotfile in "${FILES_TO_SYMLINK[@]}"; do
    sourceFile="$(pwd)/${dotfile}"
    targetFile="${HOME}/.$(printf "%s" "${dotfile}" | sed "s/.*\/\(.*\)/\1/g")"

    if [[ $BUILD ]]; then
      link_file "$sourceFile" "$targetFile"
    else
      unlink_file "$sourceFile" "$targetFile"
    fi
  done

  # Symlink (or unlink) folders in the ~/.config directory.
  mkdir -p "${HOME}/.config"
  FOLDERS_TO_SYMLINK=(
    "nvim"
  )
  for configFolder in "${FOLDERS_TO_SYMLINK[@]}"; do
    sourceFolder="$(pwd)/$configFolder"
    targetFolder="${HOME}/.config/$(printf "%s" "${configFolder}" | sed "s/.*\/\(.*\)/\1/g")"

    if [[ $BUILD ]]; then
      link_file "$sourceFolder" "$targetFolder"
    else
      unlink_file "$sourceFolder" "$targetFolder"
    fi
  done

  if [[ $BUILD ]]; then
    # Install zsh (if not available) and oh-my-zsh and p10k.
    install_zsh
    install_zsh_extras
    if ! [[ $INTERACTIVE ]]; then
      install_optional_extras
    fi

    # Link gitconfig.
    git config --global include.path ~/.main.gitconfig
  else
    # Unlink gitconfig.
    git config --global --unset include.path
  fi
}

main
