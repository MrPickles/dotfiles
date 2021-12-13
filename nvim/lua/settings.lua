-- General vim settings.
vim.opt.mouse = 'a' -- Enable mouse usage.

-- Display settings.
vim.opt.background = 'dark' -- Set to dark mode.
vim.opt.wrap = false -- Disable line wrap.
vim.opt.number = true -- Show line numbers
vim.opt.termguicolors = true -- Match terminal colors with GUI program.
vim.cmd 'syntax on'

-- Indentation settings
vim.opt.tabstop = 2 -- Make tabs 2 characters wide.
vim.opt.shiftwidth = 2 -- Indent by 2 spaces by default.
vim.opt.expandtab = true -- Pressing tab converts to spaces.

-- Search settings.
vim.opt.ignorecase = true -- Ignore case sensitivity.
vim.opt.smartcase = true -- Check case for queries with uppercase letters.
vim.opt.hlsearch = true -- Highlight matching search queries.

-- Return to last edit position when opening files.
vim.cmd[[
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
]]
