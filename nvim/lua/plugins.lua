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
  use {'ishan9299/nvim-solarized-lua', config = "require('plugin.solarized')"}
  use {'norcalli/nvim-colorizer.lua', config = "require('plugin.colorizer')"}
  use {
    'feline-nvim/feline.nvim',
    config = "require('plugin.feline')",
  }
  use {
    'akinsho/bufferline.nvim',
    config = "require('plugin.bufferline')",
    requires = 'kyazdani42/nvim-web-devicons',
  }
  use {
    'kyazdani42/nvim-tree.lua',
    config = "require('plugin.nvim-tree')",
    requires = {'kyazdani42/nvim-web-devicons'},
  }
  use 'liuchengxu/vista.vim'

  -- Plugins for git and version control.
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = "require('plugin.gitsigns')",
  }

  -- LSP plugins.
  use 'neovim/nvim-lspconfig'
  use {'williamboman/nvim-lsp-installer', config = "require('plugin.lsp')"}
  use 'ray-x/lsp_signature.nvim'

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
    config = "require('plugin.cmp')"
  }

  -- Treesitter for better syntax highlighting and whatnot.
  use {
    'nvim-treesitter/nvim-treesitter',
    config = "require('plugin.treesitter')",
    run = ':TSUpdate',
  }
  use {
    'SmiteshP/nvim-gps',
    config = "require('plugin.gps')",
    requires = 'nvim-treesitter/nvim-treesitter',
  }
  -- Vim Polyglot for the languages not supported by Treesitter.
  use 'sheerun/vim-polyglot'

  -- Telescope for better searching and whatnot.
  use {
    'nvim-telescope/telescope.nvim',
    config = "require('plugin.telescope')",
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-treesitter/nvim-treesitter'},
      {'kyazdani42/nvim-web-devicons'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
    },
  }

  -- We would still like Neovim to manage fzf installation.
  use {'junegunn/fzf', run = function() vim.fn['fzf#install']() end}

  -- Language-specific plugins.
  use 'tweekmonster/gofmt.vim'
  use {'bazelbuild/vim-bazel', requires = 'google/vim-maktaba'}

  -- Miscellaneous plugins.
  use 'psliwka/vim-smoothie'
  use {'nacro90/numb.nvim', config = "require('plugin.numb')"}

  -- Automatically sync all packages if we're bootstrapping.
  if bootstrap then
    packer.sync()
  end
end)
