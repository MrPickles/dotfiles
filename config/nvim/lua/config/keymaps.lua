-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map <ctrl-l> and <ctrl-h> to go to the next and previous buffers.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-l>", ":bnext<cr>", opts)
vim.keymap.set("n", "<C-h>", ":bprev<cr>", opts)
