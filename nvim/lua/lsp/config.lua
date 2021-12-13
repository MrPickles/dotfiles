local M = {}

-- All of the LSPs we'll install by default.
M.servers = {
  'bashls', -- Bash
  'clangd', -- C/C++
  'clojure_lsp', -- Clojure
  'dockerls', -- Docker
  'gopls', -- Go
  'graphql', -- GraphQL
  'html', -- HTML
  'jsonls', -- JSON
  'jdtls', --Java
  'ocamlls', --OCaml
  'pyright', -- Python
  'solargraph', -- Ruby
  'sqlls', -- SQL
  'sumneko_lua', -- Lua
  'terraformls', -- Terraform
  'tsserver', -- JavaScript/TypeScript
  'vimls', -- VimL
  'volar', -- Vue
  'lemminx', -- XML
  'yamlls', -- YAML
}

M.settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim' }
    }
  }
}

return M
