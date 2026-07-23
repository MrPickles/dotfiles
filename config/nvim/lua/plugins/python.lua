local project_markers = {
  "pyproject.toml",
  "uv.lock",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
  ".git",
}

local local_interpreters = {
  ".venv/bin/python",
  "venv/bin/python",
  ".venv/Scripts/python.exe",
  "venv/Scripts/python.exe",
}

local function find_project_python(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "python" then
    return nil
  end

  local file = vim.api.nvim_buf_get_name(buf)
  local root = file ~= "" and vim.fs.root(file, project_markers) or nil
  if not root then
    return nil
  end

  for _, relative_path in ipairs(local_interpreters) do
    local python = vim.fs.joinpath(root, relative_path)
    if vim.fn.executable(python) == 1 then
      return python
    end
  end
end

return {
  {
    "linux-cultist/venv-selector.nvim",
    config = function(_, opts)
      local venv_selector = require("venv-selector")
      venv_selector.setup(opts)

      local function activate_local_venv(buf)
        -- activate_from_path() operates on the current buffer.
        if buf ~= vim.api.nvim_get_current_buf() then
          return
        end

        local python = find_project_python(buf)
        if python and venv_selector.python() ~= python then
          venv_selector.activate_from_path(python)
        end
      end

      local group = vim.api.nvim_create_augroup("AutoActivateProjectVenv", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "python",
        callback = function(event)
          vim.schedule(function()
            activate_local_venv(event.buf)
          end)
        end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function(event)
          vim.schedule(function()
            activate_local_venv(event.buf)
          end)
        end,
      })

      -- The plugin is itself loaded by the first Python FileType event, so its
      -- newly registered autocmd does not see that event.
      vim.schedule(function()
        activate_local_venv(vim.api.nvim_get_current_buf())
      end)
    end,
  },
}
