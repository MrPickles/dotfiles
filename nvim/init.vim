" Load Impatient before anything else.
" Since this may fail if we're bootstrapping, we use a pcall.
lua pcall(require, 'impatient')

lua require('plugins')
lua require('settings')
lua require('keybindings')

" Source custom configs (not under version control).
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
