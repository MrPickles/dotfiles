require("config.lazy")

-- Source custom configs (not under version control).
vim.cmd([[
  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
]])
