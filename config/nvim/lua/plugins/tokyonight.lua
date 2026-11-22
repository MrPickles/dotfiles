local is_day = vim.env.DOTFILES_TOKYONIGHT_STYLE == "day"

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = is_day and "day" or "storm",
      light_style = "day",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = is_day and "tokyonight-day" or "tokyonight-storm" },
  },
}
