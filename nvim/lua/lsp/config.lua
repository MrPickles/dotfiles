local M = {}

-- Only install the Lua LSP by default.
-- To install others take a look at :LspInstallInfo
M.servers = {
  'sumneko_lua',
}

M.settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim' }
    }
  }
}

return M
