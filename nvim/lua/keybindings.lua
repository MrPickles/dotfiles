-- Abbreviate common commands.
vim.cmd('command! PI PackerInstall')
vim.cmd('command! PS PackerSync')
vim.cmd('command! PST PackerStatus')
vim.cmd('command! LSP LspInstall')
vim.cmd('command! LS Mason')

-- Alias most permutations of capitalized 'wqa' commands to work.
vim.cmd('command! Q q')
vim.cmd('command! W w')
vim.cmd('command! WQ wq')
vim.cmd('command! Wq wq')
vim.cmd('command! WA wa')
vim.cmd('command! Wa wa')
vim.cmd('command! QA qa')
vim.cmd('command! Qa qa')
vim.cmd('command! Wqa wqa')
vim.cmd('command! WQa wqa')
vim.cmd('command! WQA wqa')

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Map <ctrl-l> and <ctrl-h> to go to the next and previous buffers.
vim.keymap.set('n', '<C-l>', ':bnext<cr>', opts)
vim.keymap.set('n', '<C-h>', ':bprev<cr>', opts)

-- Set <ctrl-p> to open Telescope file search.
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>', opts)
-- Set <ctrl-g> to open Telescope grep.
vim.keymap.set('n', '<C-g>', ':Telescope live_grep<cr>', opts)
-- Set <ctrl-n> to toggle nvim-tree.
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', opts)

-- Remap <ctrl-c> to <esc>. This prevents cmp-buffer from running into errors.
-- https://github.com/hrsh7th/cmp-buffer/issues/30#issuecomment-994011089
vim.keymap.set('i', '<C-c>', '<Esc>\\`^', opts)
