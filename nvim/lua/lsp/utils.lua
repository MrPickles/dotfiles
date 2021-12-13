local lsp_installer_servers = require('nvim-lsp-installer.servers')

local M = {}

M.install_lsp = function(server_name)
  local ok, server = lsp_installer_servers.get_server(server_name)
  if not ok then
    return
  end
  if server:is_installed() then
    return
  end
  server:install()
end

return M
