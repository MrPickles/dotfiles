local config = require('lsp.config')
local utils = require('lsp.utils')

local M = {}

M.install_all = function()
  for _, server in ipairs(config.servers) do
    utils.install_lsp(server)
  end
end

M.settings = config.settings

return M
