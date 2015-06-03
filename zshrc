ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dpoggi"

plugins=(git bundler brew gem rbates)

export PATH="/usr/local/bin:$PATH"
export EDITOR='vim'

source $ZSH/oh-my-zsh.sh

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export LSCOLORS='Exfxcxdxcxegedabagacad'
