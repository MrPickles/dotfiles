#!/usr/bin/env bash

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

linux_release_field() {
  local key=$1

  if [[ ! -r /etc/os-release ]]; then
    return 1
  fi

  awk -F= -v key="${key}" '$1 == key { gsub(/"/, "", $2); print $2 }' /etc/os-release
}

run_as_root() {
  # sudo env_reset drops the caller's DEBIAN_FRONTEND; pass it on the command.
  local frontend="${DEBIAN_FRONTEND:-noninteractive}"

  if [[ "${EUID}" -eq 0 ]]; then
    env DEBIAN_FRONTEND="${frontend}" "$@"
  else
    sudo DEBIAN_FRONTEND="${frontend}" "$@"
  fi
}

eval_brew_shellenv() {
  local brew_bin=""

  if [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    brew_bin=/home/linuxbrew/.linuxbrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin=/usr/local/bin/brew
  elif has_cmd brew; then
    brew_bin=$(command -v brew)
  else
    return 1
  fi

  eval "$("${brew_bin}" shellenv bash)"
}

ensure_homebrew() {
  if [[ "${EUID}" -eq 0 ]]; then
    echo "Homebrew must be installed as a non-root user with sudo." >&2
    exit 1
  fi

  if eval_brew_shellenv; then
    hash -r
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if ! eval_brew_shellenv; then
    echo "Unable to find Homebrew after installation." >&2
    exit 1
  fi
  hash -r
}

install_brewfile() {
  brew update
  brew bundle install --file="${DOTFILES_ROOT}/Brewfile"
}
