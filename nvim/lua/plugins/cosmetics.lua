return {
  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme solarized")
    end,
  },
  -- Show blank line indentation levels.
  { "lukas-reineke/indent-blankline.nvim" },
  -- Allow smooth scrolling
  { "psliwka/vim-smoothie" },
  -- Highlight hex colors.
  { "norcalli/nvim-colorizer.lua", config = true },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
    init = function()
      -- Set <ctrl-n> to toggle nvim-tree.
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },
  { "feline-nvim/feline.nvim", config = true },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        show_buffer_close_icons = false,
        show_tab_indicators = true,
      },
    },
  },
}
