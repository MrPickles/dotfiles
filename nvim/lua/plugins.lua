local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local compile_path = install_path..'/plugin/packer_compiled.lua'
local bootstrap = vim.fn.empty(vim.fn.glob(install_path)) > 0

-- For new installations, we may not have packer.
-- We need to manually clone and install the package manager.
if bootstrap then
  vim.api.nvim_command('!git clone --filter=blob:none https://github.com/wbthomason/packer.nvim '..install_path)
  vim.api.nvim_command('packadd packer.nvim')
end

local packer = require('packer')
-- Specify a custom compile path, since we don't want it next to our configs.
packer.init({compile_path = compile_path})
packer.startup(function(use)
  -- Let packer.nvim manage itself.
  use 'wbthomason/packer.nvim'

  -- Performance-related plugins.
  use 'lewis6991/impatient.nvim'

  -- Sensible defaults.
  use 'tpope/vim-sensible'

  -- Cosmetic plugins.
  use 'lukas-reineke/indent-blankline.nvim'
  use {
    'ishan9299/nvim-solarized-lua',
    config = function()
      vim.cmd('colorscheme solarized')
    end,
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }
  use {
    'feline-nvim/feline.nvim',
    config = function()
      require('feline').setup()
    end,
  }
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('config.bufferline')
    end,
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function()
      require('nvim-tree').setup()
    end,
  }
  use 'liuchengxu/vista.vim'

  -- Plugins for git and version control.
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup()
    end,
  }

  -- LSP plugins.
  use {
    -- NOTE: Not all plugins have init.lua. Be careful about this.
    -- Not all config directives will run, as a result.
    'williamboman/mason.nvim',
    requires = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'ray-x/lsp_signature.nvim',
    },
    config = function()
      require('config.lsp')
    end,
  }

  -- Completion engine and dependencies.
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'onsails/lspkind-nvim',
    },
    config = function()
      require('config.cmp')
    end,
  }

  -- Treesitter for better syntax highlighting and whatnot.
  use {
    'nvim-treesitter/nvim-treesitter',
    config = "require('config.treesitter')",
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }
  -- Show what function/class you're in.
  use 'nvim-treesitter/nvim-treesitter-context'
  -- Vim Polyglot for the languages not supported by Treesitter.
  use 'sheerun/vim-polyglot'

  -- Telescope for better searching and whatnot.
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-treesitter/nvim-treesitter'},
      {'kyazdani42/nvim-web-devicons'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
    },
    config = function()
      require('config.telescope')
    end,
  }

  -- We would still like Neovim to manage fzf installation.
  use {
    'junegunn/fzf',
    run = function()
      vim.fn['fzf#install']()
    end,
  }

  -- Language-specific plugins.
  use 'tweekmonster/gofmt.vim'

  -- Miscellaneous plugins.
  use 'psliwka/vim-smoothie'
  use {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end,
  }

  -- Automatically sync all packages if we're bootstrapping.
  if bootstrap then
    packer.sync()
  end
end)
