return {
  -- Let lazy.nvim manage itself.
  { "folke/lazy.nvim", version = "*" },

  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme solarized")
    end,
  },

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

  -- Set up language server protocol.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim", config = true },
    },
    config = function()
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

      local function on_attach(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<space>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
        require("lspconfig")[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end
    end,
  },


  -- Manage completion and snippets.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    init = function()
      -- Remap <ctrl-c> to <esc>. This prevents cmp-buffer from running into errors.
      -- https://github.com/hrsh7th/cmp-buffer/issues/30#issuecomment-994011089
      vim.keymap.set("i", "<C-c>", "<Esc>\\`^", { noremap = true, silent = true })
    end,
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      cmp.setup({
        -- Set the snippet generator. We use the "default" one written by the same author of this library.
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Configure keyboard shortcuts for the completion menu.
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          -- Pressing tab will select the next item.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Pressing <shift-tab> will select the previous item.
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        -- Add sources to the completion engine. (These are the dependencies we configured.)
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "calc" },
        }),
        formatting = {
          -- Format completions with an emoji.
          format = lspkind.cmp_format(),
        }
      })
    end,
  },

  -- Treesitter gives us better syntax highlighting than regex-based parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- Show what function/class you're in.
      "nvim-treesitter/nvim-treesitter-context",
    },
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

  -- Show blank line indentation levels.
  { "lukas-reineke/indent-blankline.nvim" },
  -- Allow smooth scrolling
  { "psliwka/vim-smoothie" },
  -- Highlight hex colors.
  { "norcalli/nvim-colorizer.lua", config = true },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("evil_lualine")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      { "nvim-tree/nvim-tree.lua", config = true },
      { "nvim-tree/nvim-web-devicons" },
    },
    init = function()
      -- Required setting for this plugin.
      vim.opt.termguicolors = true
      -- Set <ctrl-n> to toggle nvim-tree.
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
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

  -- Version control plugins.
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  -- Run gofmt on save.
  { "tweekmonster/gofmt.vim", ft = "go" },
}
