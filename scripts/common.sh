#!/usr/bin/env bash

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

version_gte() {
  dpkg --compare-versions "$1" ge "$2"
}

linux_release_field() {
  local key=$1

  if [[ ! -r /etc/os-release ]]; then
    return 1
  fi

  awk -F= -v key="${key}" '$1 == key { gsub(/"/, "", $2); print $2 }' /etc/os-release
}

linux_arch() {
  case "$(uname -m)" in
    x86_64|amd64)
      echo "x86_64"
      ;;
    aarch64|arm64)
      echo "arm64"
      ;;
    *)
      echo "Unsupported architecture: $(uname -m)" >&2
      exit 1
      ;;
  esac
}

latest_github_asset() {
  local repo=$1
  local pattern=$2

  curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
    | jq -r --arg pattern "${pattern}" '
        .assets[]
        | select(.name | test($pattern))
        | .browser_download_url
      ' \
    | head -n1
}

require_url() {
  local url=$1
  local description=$2

  if [[ -z "${url}" ]]; then
    echo "Unable to find a download URL for ${description}." >&2
    exit 1
  fi
}

run_as_root() {
  if [[ "${EUID}" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

ensure_symlink() {
  local target=$1
  local link_path=$2

  mkdir -p "$(dirname "${link_path}")"
  ln -sfn "${target}" "${link_path}"
}
