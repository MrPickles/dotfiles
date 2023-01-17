return {
  -- Treesitter gives us better syntax highlighting than regex-based parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "lua",
        "vim",
        "help"
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },

  -- Show what function/class you're in.
  { "nvim-treesitter/nvim-treesitter-context" },

  -- Telescope for better searching and whatnot.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    init = function()
      local opts = { noremap = true, silent = true }
      -- Set <ctrl-p> to open Telescope file search.
      vim.keymap.set("n", "<C-p>", ":Telescope find_files<cr>", opts)
      -- Set <ctrl-g> to open Telescope grep.
      vim.keymap.set("n", "<C-g>", ":Telescope live_grep<cr>", opts)
    end,
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          }
        }
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
