-- General vim settings.
vim.opt.mouse = 'a' -- Enable mouse usage.

-- Display settings.
vim.opt.background = 'dark' -- Set to dark mode.
vim.opt.wrap = false -- Disable line wrap.
vim.opt.number = true -- Show line numbers
vim.opt.termguicolors = true -- Match terminal colors with GUI program.
vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons

-- Indentation settings
vim.opt.cindent = true -- Enable modern C-style indentation.
vim.opt.tabstop = 2 -- Make tabs 2 characters wide.
vim.opt.shiftwidth = 2 -- Indent by 2 spaces by default.
vim.opt.expandtab = true -- Pressing tab converts to spaces...
-- ...except for Makefiles and Go, where we explicitly want tabs.
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "go", "make" },
  callback = function()
    vim.opt.expandtab = false
  end,
})
vim.filetype.add({
  extension = {
    -- Set files like "main.gitconfig" to be gitconfig files.
    gitconfig = "gitconfig"
  },
})
vim.cmd([[filetype plugin indent on]]) -- Enable filetype-specific indentation.

-- Search settings.
vim.opt.ignorecase = true -- Ignore case sensitivity.
vim.opt.smartcase = true -- Check case for queries with uppercase letters.
vim.opt.hlsearch = true -- Highlight matching search queries.

-- Return to last edit position when opening files.
vim.cmd([[
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
]])

-- Alias most permutations of capitalized "wqa" commands to work.
vim.cmd("command! Q q")
vim.cmd("command! W w")
vim.cmd("command! WQ wq")
vim.cmd("command! Wq wq")
vim.cmd("command! WA wa")
vim.cmd("command! Wa wa")
vim.cmd("command! QA qa")
vim.cmd("command! Qa qa")
vim.cmd("command! Wqa wqa")
vim.cmd("command! WQa wqa")
vim.cmd("command! WQA wqa")

-- Map <ctrl-l> and <ctrl-h> to go to the next and previous buffers.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-l>", ":bnext<cr>", opts)
vim.keymap.set("n", "<C-h>", ":bprev<cr>", opts)

vim.diagnostic.config({
  virtual_lines = true
})
