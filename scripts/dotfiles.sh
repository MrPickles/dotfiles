#!/usr/bin/env bash

# This is the one-liner installation script for these dotfiles. To install,
# run one of these commands...
#
# curl -L andrew.cloud/dotfiles.sh | bash
# or
# wget -qO- andrew.cloud/dotfiles.sh | bash
# or
# curl https://raw.githubusercontent.com/MrPickles/dotfiles/master/scripts/dotfiles.sh | bash
#
# Extra setup.sh flags can be forwarded through the bootstrap script:
# curl .../dotfiles.sh | bash -s -- --install-deps

main() {
  readonly dotfilesDir="${HOME}/.dotfiles"
  readonly repo="https://github.com/MrPickles/dotfiles"

  if ! command -v git >/dev/null 2>&1; then
    echo "This bootstrap script requires git. Aborting."
    exit 1
  fi

  if [[ -d "$dotfilesDir" ]]; then
    echo "The dotfiles directory (${dotfilesDir}) already exists. We will assume you already cloned the correct repository."
  else
    git clone --quiet --filter=blob:none "${repo}" "${dotfilesDir}"
  fi

  cd "${dotfilesDir}" || exit
  ./setup.sh "$@"
}

main "$@"
