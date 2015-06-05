ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dpoggi"

plugins=(git bundler brew gem rbates)

export PATH="/usr/local/bin:$PATH"
export EDITOR='vim'

source $ZSH/oh-my-zsh.sh

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export LSCOLORS='exfxcxdxcxegedabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
