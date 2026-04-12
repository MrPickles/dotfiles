#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${script_dir}/common.sh"

TOOL_SOURCE="distro"
NEOVIM_SOURCE="github"
DISTRO_ID=""
DISTRO_VERSION_ID=""
DISTRO_CODENAME=""
APT_UPDATED=false

# Version floors justified by the current repo config:
# - Neovim: repo policy. LazyVim upstream requires >= 0.11.2, but this config
#   targets modern behavior and should stay on >= 0.12.0.
# - fzf: `home/zshrc` uses `fzf --zsh`, which requires fzf >= 0.48.0.
# - tree-sitter-cli: current `nvim-treesitter` main requires >= 0.26.1.
readonly MIN_NEOVIM_VERSION="0.12.0"
readonly MIN_FZF_VERSION="0.48.0"
readonly MIN_TREE_SITTER_CLI_VERSION="0.26.1"

usage() {
  cat <<'EOF'
Usage: linux.sh [--tool-source <distro|cargo>] [--neovim-source <github>]

Installs the shared Linux package set plus editor/tooling extras.

Options:
  --tool-source     Where to install Rust-based CLI tools from.
                    distro = apt/main repos, extra apt repos, or upstream binaries
                    cargo  = cargo install for Rust-based CLI tools
  --neovim-source   Currently only supports "github" for the latest stable release.
  -h, --help        Show this message.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tool-source)
        TOOL_SOURCE=$2
        shift 2
        ;;
      --neovim-source)
        NEOVIM_SOURCE=$2
        shift 2
        ;;
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

validate_args() {
  case "${TOOL_SOURCE}" in
    distro|cargo)
      ;;
    *)
      echo "Unsupported tool source: ${TOOL_SOURCE}" >&2
      exit 1
      ;;
  esac

  if [[ "${NEOVIM_SOURCE}" != "github" ]]; then
    echo "Unsupported neovim source: ${NEOVIM_SOURCE}" >&2
    exit 1
  fi
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

apt_update() {
  if [[ "${APT_UPDATED}" != "true" ]]; then
    run_as_root apt update
    APT_UPDATED=true
  fi
}

install_apt_packages() {
  apt_update
  run_as_root apt install -y "$@"
}

apt_package_candidate_version() {
  apt_update
  apt-cache policy "$1" | awk '/Candidate:/ {print $2; exit}'
}

apt_package_available() {
  local version
  version=$(apt_package_candidate_version "$1")
  [[ -n "${version}" && "${version}" != "(none)" ]]
}

apt_package_meets_min_version() {
  local version
  version=$(apt_package_candidate_version "$1")
  [[ -n "${version}" && "${version}" != "(none)" ]] && version_gte "${version}" "$2"
}

apt_package_is_acceptable() {
  local package_name=$1
  local policy=$2
  local min_version=${3:-}

  case "${policy}" in
    available)
      apt_package_available "${package_name}"
      ;;
    min_version)
      apt_package_meets_min_version "${package_name}" "${min_version}"
      ;;
    *)
      echo "Unsupported apt policy: ${policy}" >&2
      exit 1
      ;;
  esac
}

ensure_rustup() {
  if [[ -f "${HOME}/.cargo/env" ]]; then
    # shellcheck disable=SC1090,SC1091
    source "${HOME}/.cargo/env"
  fi

  if has_cmd cargo; then
    return
  fi

  curl -fsSL https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1090,SC1091
  source "${HOME}/.cargo/env"
}

install_cargo_tool() {
  local crate=$1

  ensure_rustup
  cargo install --locked "${crate}"
}

install_neovim_from_github() {
  local arch
  local tmpdir

  arch=$(linux_arch)
  tmpdir=$(mktemp -d)

  curl -fsSL -o "${tmpdir}/nvim-linux-${arch}.tar.gz" \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz"
  run_as_root rm -rf "/opt/nvim-linux-${arch}"
  run_as_root tar -C /opt -xzf "${tmpdir}/nvim-linux-${arch}.tar.gz"
  run_as_root ln -sf "/opt/nvim-linux-${arch}/bin/nvim" /usr/local/bin/nvim

  rm -rf "${tmpdir}"
}

install_fzf_from_github() {
  local arch
  local asset_arch
  local fzf_url
  local archive_name
  local tmpdir

  arch=$(linux_arch)
  case "${arch}" in
    x86_64)
      asset_arch="linux_amd64"
      ;;
    arm64)
      asset_arch="linux_arm64"
      ;;
    *)
      echo "Unsupported architecture for fzf: ${arch}" >&2
      exit 1
      ;;
  esac

  fzf_url=$(latest_github_asset "junegunn/fzf" "fzf-.*-${asset_arch}\\.tar\\.gz$")
  require_url "${fzf_url}" "fzf (${asset_arch})"

  archive_name="${fzf_url##*/}"
  tmpdir=$(mktemp -d)
  wget -O "${tmpdir}/${archive_name}" "${fzf_url}"
  tar -C "${tmpdir}" -xzf "${tmpdir}/${archive_name}"
  run_as_root install -m 0755 "${tmpdir}/fzf" /usr/local/bin/fzf
  rm -rf "${tmpdir}"
}

install_delta_from_github() {
  local arch
  local delta_url
  local delta_package

  arch=$(linux_arch)
  delta_url=$(latest_github_asset "dandavison/delta" "git-delta-musl_.*_${arch}\\.deb$")
  require_url "${delta_url}" "delta (${arch})"

  delta_package="${delta_url##*/}"
  wget "${delta_url}"
  run_as_root dpkg -i "${delta_package}"
  rm -f "${delta_package}"
}

install_tree_sitter_from_github() {
  local arch
  local pattern
  local tree_sitter_url
  local archive_name
  local binary_name

  arch=$(linux_arch)
  if [[ "${arch}" == "arm64" ]]; then
    pattern='tree-sitter-linux-arm64\.gz$'
  else
    pattern='tree-sitter-linux-(x86_64|x64)\.gz$'
  fi

  tree_sitter_url=$(latest_github_asset "tree-sitter/tree-sitter" "${pattern}")
  require_url "${tree_sitter_url}" "tree-sitter (${arch})"

  archive_name="${tree_sitter_url##*/}"
  wget "${tree_sitter_url}"
  gzip -df "${archive_name}"
  binary_name="${archive_name%.gz}"
  chmod +x "${binary_name}"
  run_as_root mv "${binary_name}" /usr/local/bin/tree-sitter
}

install_eza_from_extra_repo() {
  local tmpdir

  tmpdir=$(mktemp -d)
  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    -o "${tmpdir}/eza.asc"

  run_as_root mkdir -p /etc/apt/keyrings
  run_as_root gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg "${tmpdir}/eza.asc"
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | run_as_root tee /etc/apt/sources.list.d/gierens.list >/dev/null
  run_as_root chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

  rm -rf "${tmpdir}"
  APT_UPDATED=false
  install_apt_packages eza
}

install_zoxide_from_script() {
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

ensure_fd_compatibility() {
  if ! has_cmd fd && has_cmd fdfind; then
    if [[ "${EUID}" -eq 0 ]]; then
      ln -sfn "$(command -v fdfind)" /usr/local/bin/fd
    else
      ensure_symlink "$(command -v fdfind)" "${HOME}/.local/bin/fd"
    fi
  fi
}

install_baseline_packages() {
  local common_apt_packages=(
    build-essential
    ca-certificates
    curl
    git
    gpg
    jq
    mosh
    sudo
    tmux
    tree
    unzip
    vim
    wget
    zsh
  )

  install_apt_packages "${common_apt_packages[@]}"
}

install_fzf() {
  if apt_package_is_acceptable fzf min_version "${MIN_FZF_VERSION}"; then
    install_apt_packages fzf
  else
    install_fzf_from_github "${MIN_FZF_VERSION}"
  fi
}

install_bat() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool bat
  else
    install_apt_packages bat
  fi
}

install_fd() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool fd-find
  else
    install_apt_packages fd-find
  fi

  ensure_fd_compatibility
}

install_ripgrep() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool ripgrep
  else
    install_apt_packages ripgrep
  fi
}

install_neovim() {
  if apt_package_is_acceptable neovim min_version "${MIN_NEOVIM_VERSION}"; then
    install_apt_packages neovim
  else
    install_neovim_from_github "${MIN_NEOVIM_VERSION}"
  fi
}

install_eza() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool eza
  elif apt_package_is_acceptable eza available; then
    install_apt_packages eza
  else
    install_eza_from_extra_repo
  fi
}

install_delta() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool git-delta
  elif apt_package_is_acceptable git-delta available; then
    install_apt_packages git-delta
  else
    install_delta_from_github
  fi
}

install_tree_sitter_cli() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool tree-sitter-cli
  elif apt_package_is_acceptable tree-sitter-cli min_version "${MIN_TREE_SITTER_CLI_VERSION}"; then
    install_apt_packages tree-sitter-cli
  else
    install_tree_sitter_from_github "${MIN_TREE_SITTER_CLI_VERSION}"
  fi
}

install_zoxide() {
  if [[ "${TOOL_SOURCE}" == "cargo" ]]; then
    install_cargo_tool zoxide
  elif apt_package_is_acceptable zoxide available; then
    install_apt_packages zoxide
  else
    install_zoxide_from_script
  fi
}

main() {
  parse_args "$@"
  validate_args
  detect_linux_release

  echo "Installing Linux dependencies for $(release_label) (tool source: ${TOOL_SOURCE})"

  install_baseline_packages
  install_fzf
  install_bat
  install_fd
  install_ripgrep
  install_neovim
  install_eza
  install_delta
  install_tree_sitter_cli
  install_zoxide
}

main "$@"
