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

# Prompt to switch to zsh and oh-my-zsh if not active on terminal.
if [ ! -f /bin/zsh -a ! -f /usr/bin/zsh -o ! -d $HOME/.oh-my-zsh/ ]; then
  ask_for_confirmation "Switch to zsh and oh-my-zsh?"
  if answer_is_yes; then
    install_zsh
  fi
fi

for i in ${FILES_TO_UNLINK[@]}; do
  sourceFile="$(pwd)/$i"
  targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

  if [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
    execute "unlink $targetFile" "$targetFile"
  fi
done

