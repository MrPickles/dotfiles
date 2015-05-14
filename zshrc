ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rbates"

plugins=(git bundler brew gem rbates)

export PATH="/usr/local/bin:$PATH"
export EDITOR='vim'
export LSCOLORS='exfxcxdxcxegedabagacad'

source $ZSH/oh-my-zsh.sh

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
