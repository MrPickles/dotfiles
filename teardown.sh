#!/bin/bash

# Teardown script. This unlinks all the symlinks made in the setup script.

print_unlink_success() {
  # Print output in cyan
  printf "\e[0;36m  [✔] Unlinked $1\e[0m\n"
}

print_unlink_error() {
  # Print output in red
  printf "\e[0;31m  [✖] Failed to unlink $1 $2\e[0m\n"
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

print_result() {
  [ $1 -eq 0 ] \
    && print_unlink_success "$2" \
    || print_unlink_error "$2"

  [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}

declare -a FILES_TO_UNLINK=(
  'editor/vim'
  'editor/vimrc'

  'git/gitattributes'
  'git/gitconfig'
  'git/gitignore'

  'shell/dircolors.256dark'
  'shell/tmux.conf'
  'shell/zshrc'

  'bin'
  'powerline'
)

for i in ${FILES_TO_UNLINK[@]}; do
  sourceFile="$(pwd)/$i"
  targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

  if [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
    execute "unlink $targetFile" "$targetFile"
  fi
done

# Unlink custom zsh theme.
targetFile="$HOME/.oh-my-zsh/custom/pickles.zsh-theme"
execute "unlink $targetFile" "$targetFile"

