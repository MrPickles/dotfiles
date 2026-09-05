#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${script_dir}/common.sh"

DISTRO_ID=""
DISTRO_VERSION_ID=""
DISTRO_CODENAME=""

usage() {
  cat <<'EOF'
Usage: linux.sh

Installs apt bootstrap packages, Homebrew, and the shared Brewfile tools.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown argument: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

detect_linux_release() {
  DISTRO_ID=$(linux_release_field ID)
  DISTRO_VERSION_ID=$(linux_release_field VERSION_ID)
  DISTRO_CODENAME=$(linux_release_field VERSION_CODENAME)

  case "${DISTRO_ID}" in
    ubuntu|debian)
      ;;
    *)
      echo "Unsupported Linux distribution: ${DISTRO_ID:-unknown}" >&2
      exit 1
      ;;
  esac
}

release_label() {
  if [[ -n "${DISTRO_CODENAME}" ]]; then
    echo "${DISTRO_ID} ${DISTRO_CODENAME}"
  elif [[ -n "${DISTRO_VERSION_ID}" ]]; then
    echo "${DISTRO_ID} ${DISTRO_VERSION_ID}"
  else
    echo "${DISTRO_ID}"
  fi
}

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

  run_as_root apt-get update
  run_as_root apt-get install -y --no-install-recommends "${packages[@]}"
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

  detect_linux_release

  echo "Installing Linux dependencies for $(release_label) via Homebrew"

  install_bootstrap_packages
  ensure_homebrew
  install_brewfile
}

main "$@"
