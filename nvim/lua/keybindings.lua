-- Abbreviate common commands.
vim.cmd 'command! PI PackerInstall'
vim.cmd 'command! PS PackerSync'
vim.cmd 'command! PST PackerStatus'
vim.cmd 'command! LSP LspInstall'
vim.cmd 'command! LS Mason'

-- Alias most permutations of capitalized 'wqa' commands to work.
vim.cmd 'command! Q q'
vim.cmd 'command! W w'
vim.cmd 'command! WQ wq'
vim.cmd 'command! Wq wq'
vim.cmd 'command! WA wa'
vim.cmd 'command! Wa wa'
vim.cmd 'command! QA qa'
vim.cmd 'command! Qa qa'
vim.cmd 'command! Wqa wqa'
vim.cmd 'command! WQa wqa'
vim.cmd 'command! WQA wqa'

-- Map <ctrl-l> and <ctrl-h> to go to the next and previous buffers.
vim.api.nvim_set_keymap('n', '<C-l>', ':bnext<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':bprev<cr>', { noremap = true })

-- Set <ctrl-p> to open Telescope file search.
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<cr>', { noremap = true })
-- Set <ctrl-g> to open Telescope grep.
vim.api.nvim_set_keymap('n', '<C-g>', ':Telescope live_grep<cr>', { noremap = true })
-- Set <ctrl-n> to toggle nvim-tree.
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })

-- Remap <ctrl-c> to <esc>. This prevents cmp-buffer from running into errors.
-- https://github.com/hrsh7th/cmp-buffer/issues/30#issuecomment-994011089
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>\\`^', { noremap = true })
