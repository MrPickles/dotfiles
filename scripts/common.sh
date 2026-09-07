#!/usr/bin/env bash

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

eval_brew_shellenv() {
  for bin in \
    "${HOME}/.linuxbrew/bin/brew" \
    /home/linuxbrew/.linuxbrew/bin/brew \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew
  do
    if [[ -x "${bin}" ]]; then
      eval "$("${bin}" shellenv bash)"
      return 0
    fi
  done

  if has_cmd brew; then
    eval "$(brew shellenv bash)"
    return 0
  fi

  return 1
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
