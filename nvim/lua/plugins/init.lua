return {
  {
    'ishan9299/nvim-solarized-lua',
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme solarized]])
    end,
  },

  -- Sensible defaults.
  'tpope/vim-sensible',

  -- Cosmetic plugins.
  'lukas-reineke/indent-blankline.nvim',
  {
    'ishan9299/nvim-solarized-lua',
    config = function()
      vim.cmd('colorscheme solarized')
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'feline-nvim/feline.nvim',
    config = function()
      require('feline').setup()
    end,
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('config.bufferline')
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup()
    end,
  },

  -- Plugins for git and version control.
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- LSP plugins.
  {
    -- NOTE: Not all plugins have init.lua. Be careful about this.
    -- Not all config directives will run, as a result.
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('config.lsp')
    end,
  },

  -- Completion engine and dependencies.
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'onsails/lspkind-nvim',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('config.cmp')
    end,
  },

  -- Treesitter for better syntax highlighting and whatnot.
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('config.treesitter')
    end,
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  },
  -- Show what function/class you're in.
  'nvim-treesitter/nvim-treesitter-context',

  -- Telescope for better searching and whatnot.
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('config.telescope')
    end,
  },

  -- We would still like Neovim to manage fzf installation.
  {
    'junegunn/fzf',
    version = '*',
    build = function()
      vim.fn['fzf#install']()
    end,
  },

  -- Language-specific plugins.
  'tweekmonster/gofmt.vim',

  -- Miscellaneous plugins.
  'psliwka/vim-smoothie',


}
