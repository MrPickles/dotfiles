#!/usr/bin/env bash

# Configuration script to symlink the dotfiles or clean up the symlinks.
# The script should take a target flag stating whether "build" or "clean". The
# first option will symlink all of the dotfiles and attempt to install
# oh-my-zsh. Otherwise, the script will simply remove all symlinks.

usage="Usage: $0 [-h] [-t <build|clean|shellcheck>]"
BUILD=true

# Run the symlinking from the repo root.
cd "$(dirname "$0")" || exit

while getopts :ht: option; do
  case "${option}" in
    h)
      echo "${usage}"
      echo
      echo "OPTIONS"
      echo "-h                 Output verbose usage message"
      echo "-t build           Set up dotfile symlinks and configure oh-my-zsh"
      echo "-t clean           Remove all existing dotfiles symlinks"
      echo "-t shellcheck      Lint all shell scripts"
      exit;;
    t)
      if [[ "build" =~ ^${OPTARG} ]]; then
        BUILD=true
      elif [[ "clean" =~ ^${OPTARG} ]]; then
        BUILD=
      elif [[ "shellcheck" =~ ^${OPTARG} ]]; then
        shopt -s globstar
        shellcheck -x -- **/*.sh
        exit $?
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

execute() {
  cmd=$1
  msg=$2

  eval "${cmd}"
  if [[ $? ]]; then
    # Print output in green.
    printf "\e[0;32m  [✔] %s\e[0m\n" "${msg}"
  else
    # Print output in red.
    printf "\e[0;31m  [✖] %s\e[0m\n" "${msg}"
  fi
}

install_omz() {
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
  THEME_VERSION_TAG="master"
  if [[ -x "$(command -v jq)" ]]; then
    THEME_VERSION_TAG=$(curl -s https://api.github.com/repos/romkatv/powerlevel10k/releases/latest | jq -r .tag_name)
  fi
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

link_file() {
  local source=$1
  local target=$2

  # We've already symlinked, do nothing.
  if [[ "$(readlink "${target}")" == "${source}" ]]; then
    return
  fi

  # If the target location exists and it's not our target symlink, we create a backup.
  if [[ -e "${target}" ]]; then
    epoch=$(date +%s)
    execute "mv ${target} ${target}.${epoch}.bak" "Backing up ${target} → ${target}.${epoch}.bak"
  fi

  # Symlink the dotfile.
  execute "ln -fs ${source} ${target}" "Linking ${target} → ${source}"
}

unlink_file() {
  local source=$1
  local target=$2

  if [ "$(readlink "${target}")" == "${source}" ]; then
    execute "unlink ${target}" "Unlinking ${target} → ${source}"
  fi
}

main() {
  # Symlink (or unlink) the dotfiles.
  # Technically, this won't work for odd filenames, e.g. those with spaces or
  # newlines. However, we don't care in this case and would rather have broader
  # compatibility.
  #
  # shellcheck disable=SC2207
  FILES_TO_SYMLINK=($(find home -mindepth 1 -maxdepth 1 -type f))
  for dotfile in "${FILES_TO_SYMLINK[@]}"; do
    sourceFile="$(pwd)/${dotfile}"
    targetFile="${HOME}/.$(basename "${dotfile}")"

    if [[ $BUILD ]]; then
      link_file "$sourceFile" "$targetFile"
    else
      unlink_file "$sourceFile" "$targetFile"
    fi
  done

  # Symlink (or unlink) folders in the ~/.config directory.
  mkdir -p "${HOME}/.config"
  # shellcheck disable=SC2207
  FOLDERS_TO_SYMLINK=($(find config -mindepth 1 -maxdepth 1 -type d))
  for configFolder in "${FOLDERS_TO_SYMLINK[@]}"; do
    sourceFolder="$(pwd)/$configFolder"
    targetFolder="${HOME}/.config/$(basename "${configFolder}")"

    if [[ $BUILD ]]; then
      link_file "$sourceFolder" "$targetFolder"
    else
      unlink_file "$sourceFolder" "$targetFolder"
    fi
  done

  if [[ $BUILD ]]; then
    # Link gitconfig.
    git config --global include.path ~/.main.gitconfig

    # Install oh-my-zsh and its custom plugins/themes.
    install_omz
  else
    # Unlink gitconfig.
    git config --global --unset include.path
  fi
}

main "$@"
