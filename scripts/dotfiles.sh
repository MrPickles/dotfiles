#!/usr/bin/env bash

# This is the one-liner installation script for these dotfiles. To install,
# run one of these commands...
#
# curl -L andrew.cloud/dotfiles.sh | sh
# or
# wget -qO- andrew.cloud/dotfiles.sh | sh
# or
# curl https://raw.githubusercontent.com/MrPickles/dotfiles/master/scripts/dotfiles.sh | sh

main() {
  readonly dotfilesDir="${HOME}/.dotfiles"
  readonly repo="https://github.com/MrPickles/dotfiles"

  if [[ ! "$(command -v git)" ]]; then
    echo "This bootstrap script requires git. Aborting."
    exit 1
  fi

  if [[ -d "$dotfilesDir" ]]; then
    echo "The dotfiles directory (${dotfilesDir}) already exists. We will assume you already cloned the correct repository."
  else
    git clone --quiet --filter=blob:none "${repo}" "${dotfilesDir}"
  fi

  cd "${dotfilesDir}" || exit
  # shellcheck source=setup.sh
  . setup.sh
}

main "$@"
