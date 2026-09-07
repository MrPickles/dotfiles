#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${script_dir}/common.sh"


install_bootstrap_packages() {
  # Compiler toolchain plus the host tools Homebrew's Linux installer expects.
  local packages=(
    build-essential
    ca-certificates
    curl
    file
    git
    procps
    sudo
    unzip
    vim
    zsh
  )

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends "${packages[@]}"
}

main() {
  parse_args "$@"

  if [[ $(uname -s) != "Linux" ]]; then
    echo "This script should be run on Linux only." >&2
    exit 1
  fi

  if [[ "${EUID}" -eq 0 ]]; then
    echo "This script must be run as a non-root user with sudo. Homebrew refuses a root install." >&2
    exit 1
  fi

  if ! has_cmd apt-get; then
    echo "This script requires Debian or Ubuntu (apt-get not found)." >&2
    exit 1
  fi

  echo "Installing Linux dependencies via Homebrew"

  install_bootstrap_packages
  ensure_homebrew
  install_brewfile
}

main "$@"
