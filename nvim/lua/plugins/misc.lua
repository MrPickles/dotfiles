return {
  -- Let lazy.nvim manage itself.
  { "folke/lazy.nvim", version = "*" },
  -- Run gofmt on save.
  { "tweekmonster/gofmt.vim", ft = "go" },

  -- Neovim manages our fzf installation.
  -- It's the latest stable version of the binary.
  {
    "junegunn/fzf",
    dependencies = { "junegunn/fzf.vim" },
    version = "*",
    build = function()
      vim.fn["fzf#install"]()
    end,
    priority = 100,
  },
}
