#!/usr/bin/env bash

# Public setup entrypoint for this dotfiles repo.
# By default it symlinks the dotfiles, installs the shared git include, and
# bootstraps oh-my-zsh. Optional machine-level dependencies can also be
# installed with --install-deps.

set -euo pipefail

ACTION="build"
INSTALL_DEPS=false
TOOL_SOURCE="distro"
NEOVIM_SOURCE="github"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: ./setup.sh [options]

Default behavior:
  Build the dotfile symlinks and install/update oh-my-zsh.

Options:
  -h, --help                  Show this message.
  -t, --target <action>       One of: build, clean, shellcheck.
      --build                 Alias for --target build.
      --clean                 Alias for --target clean.
      --shellcheck            Alias for --target shellcheck.
      --install-deps          Install machine-level dependencies before build.
      --tool-source <distro|cargo>
                              Linux only. Choose how Rust-based CLI tools are installed.
      --neovim-source <github>
                              Override the Neovim install source for --install-deps.

Examples:
  ./setup.sh
  ./setup.sh --install-deps
  ./setup.sh --install-deps --tool-source cargo
  ./setup.sh --clean
  ./setup.sh --shellcheck
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      -t|--target)
        if [[ $# -lt 2 ]]; then
          echo "Missing argument for $1" >&2
          exit 1
        fi
        ACTION=$2
        shift 2
        ;;
      --build)
        ACTION="build"
        shift
        ;;
      --clean)
        ACTION="clean"
        shift
        ;;
      --shellcheck)
        ACTION="shellcheck"
        shift
        ;;
      --install-deps)
        INSTALL_DEPS=true
        shift
        ;;
      --tool-source)
        if [[ $# -lt 2 ]]; then
          echo "Missing argument for $1" >&2
          exit 1
        fi
        TOOL_SOURCE=$2
        shift 2
        ;;
      --neovim-source)
        if [[ $# -lt 2 ]]; then
          echo "Missing argument for $1" >&2
          exit 1
        fi
        NEOVIM_SOURCE=$2
        shift 2
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

validate_args() {
  case "${ACTION}" in
    build|clean|shellcheck)
      ;;
    *)
      echo "Unsupported target: ${ACTION}" >&2
      usage >&2
      exit 1
      ;;
  esac

  case "${TOOL_SOURCE}" in
    distro|cargo)
      ;;
    *)
      echo "Unsupported tool source: ${TOOL_SOURCE}" >&2
      exit 1
      ;;
  esac

  case "${NEOVIM_SOURCE}" in
    github)
      ;;
    *)
      echo "Unsupported neovim source: ${NEOVIM_SOURCE}" >&2
      exit 1
      ;;
  esac

  if [[ "${ACTION}" != "build" && "${INSTALL_DEPS}" == "true" ]]; then
    echo "--install-deps can only be used with the build target." >&2
    exit 1
  fi
}

execute() {
  local msg=$1
  shift

  if "$@"; then
    printf "\e[0;32m  [✔] %s\e[0m\n" "${msg}"
    return 0
  else
    printf "\e[0;31m  [✖] %s\e[0m\n" "${msg}"
    return 1
  fi
}

install_dependencies() {
  local os_name
  os_name=$(uname -s)

  case "${os_name}" in
    Darwin)
      execute "Installing macOS dependencies" "${script_dir}/scripts/macos.sh"
      ;;
    Linux)
      execute \
        "Installing Linux dependencies" \
        "${script_dir}/scripts/linux.sh" \
        --tool-source "${TOOL_SOURCE}" \
        --neovim-source "${NEOVIM_SOURCE}"
      ;;
    *)
      echo "Unsupported operating system: ${os_name}" >&2
      exit 1
      ;;
  esac
}

run_shellcheck() {
  shopt -s globstar
  shellcheck -x -- **/*.sh
}

install_omz() {
  local zsh_dir
  local zsh_custom
  local theme_repo_url
  local theme_path

  zsh_dir=${HOME}/.oh-my-zsh
  zsh_custom="${ZSH_CUSTOM:-${zsh_dir}/custom}"

  if [[ ! -d "${zsh_dir}" ]]; then
    git clone --quiet --filter=blob:none https://github.com/robbyrussell/oh-my-zsh "${zsh_dir}"
  else
    git -C "${zsh_dir}" pull --quiet
  fi

  theme_repo_url="https://github.com/romkatv/powerlevel10k"
  theme_path="${zsh_custom}/themes/${theme_repo_url##*/}"
  if [[ ! -d "${theme_path}" ]]; then
    git clone --quiet --filter=blob:none "${theme_repo_url}" "${theme_path}"
  else
    git -C "${theme_path}" pull --quiet
  fi

  local plugin_repo_url
  local plugin_name
  local plugin_path
  local custom_plugin_repos=(
    "https://github.com/Aloxaf/fzf-tab"
    "https://github.com/zdharma-continuum/fast-syntax-highlighting"
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/mafredri/zsh-async"
  )

  for plugin_repo_url in "${custom_plugin_repos[@]}"; do
    plugin_name="${plugin_repo_url##*/}"
    if [[ "${plugin_name}" == "zsh-async" ]]; then
      plugin_name="async"
    fi

    plugin_path="${zsh_custom}/plugins/${plugin_name}"
    if [[ ! -d "${plugin_path}" ]]; then
      git clone --quiet --filter=blob:none "${plugin_repo_url}" "${plugin_path}"
    else
      git -C "${plugin_path}" pull --quiet
    fi
  done
}

link_file() {
  local source=$1
  local target=$2
  local current_target
  local epoch

  if [[ -L "${target}" ]]; then
    current_target=$(readlink "${target}")
  else
    current_target=""
  fi

  if [[ "${current_target}" == "${source}" ]]; then
    return
  fi

  if [[ -e "${target}" ]]; then
    epoch=$(date +%s)
    execute "Backing up ${target} → ${target}.${epoch}.bak" mv "${target}" "${target}.${epoch}.bak"
  fi

  execute "Linking ${target} → ${source}" ln -fs "${source}" "${target}"
}

unlink_file() {
  local source=$1
  local target=$2
  local current_target

  if [[ -L "${target}" ]]; then
    current_target=$(readlink "${target}")
  else
    current_target=""
  fi

  if [[ "${current_target}" == "${source}" ]]; then
    execute "Unlinking ${target} → ${source}" unlink "${target}"
  fi
}

build_dotfiles() {
  local dotfile
  local source_file
  local target_file
  local config_folder
  local source_folder
  local target_folder

  while IFS= read -r dotfile; do
    source_file="${dotfile}"
    target_file="${HOME}/.$(basename "${dotfile}")"
    link_file "${source_file}" "${target_file}"
  done < <(find "${script_dir}/home" -mindepth 1 -maxdepth 1 -type f | sort)

  mkdir -p "${HOME}/.config"
  while IFS= read -r config_folder; do
    source_folder="${config_folder}"
    target_folder="${HOME}/.config/$(basename "${config_folder}")"
    link_file "${source_folder}" "${target_folder}"
  done < <(find "${script_dir}/config" -mindepth 1 -maxdepth 1 -type d | sort)

  if ! git config -f ~/.gitconfig --get-all include.path 2>/dev/null | grep -Fxq ~/.config/git/config; then
    git config -f ~/.gitconfig --add include.path ~/.config/git/config
  fi

  install_omz
}

clean_dotfiles() {
  local dotfile
  local source_file
  local target_file
  local config_folder
  local target_folder

  while IFS= read -r dotfile; do
    source_file="${dotfile}"
    target_file="${HOME}/.$(basename "${dotfile}")"
    unlink_file "${source_file}" "${target_file}"
  done < <(find "${script_dir}/home" -mindepth 1 -maxdepth 1 -type f | sort)

  while IFS= read -r config_folder; do
    target_folder="${HOME}/.config/$(basename "${config_folder}")"
    unlink_file "${config_folder}" "${target_folder}"
  done < <(find "${script_dir}/config" -mindepth 1 -maxdepth 1 -type d | sort)

  if [[ -f ~/.gitconfig ]]; then
    git config -f ~/.gitconfig --fixed-value --unset-all include.path ~/.config/git/config
  fi
}

main() {
  parse_args "$@"
  validate_args

  cd "${script_dir}" || exit 1

  case "${ACTION}" in
    shellcheck)
      run_shellcheck
      ;;
    clean)
      clean_dotfiles
      ;;
    build)
      if [[ "${INSTALL_DEPS}" == "true" ]]; then
        install_dependencies
      fi
      build_dotfiles
      ;;
  esac
}

main "$@"
