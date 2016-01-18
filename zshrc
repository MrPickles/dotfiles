ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dpoggi"

plugins=(git bundler brew gem rbates history-substring-search)

export PATH="/usr/local/bin:$PATH"
export EDITOR='vim'

source $ZSH/oh-my-zsh.sh

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [[ "$(uname -s)" == "Linux" ]]; then
  eval `dircolors ~/.dircolors`;
else
  export LSCOLORS='ExFxBxDxCxegedabagacad'
fi

bindkey -v # vi mode for shell
# key bindings for history search
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

setopt correct
setopt rmstarsilent # silence rm * confirmation

# Use 256 color for tmux.
alias tmux="TERM=screen-256color-bce tmux"

# Set terminal to use 256 color
export TERM=xterm-256color