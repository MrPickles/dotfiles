return {
  -- https://www.lazyvim.org/plugins/formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Don't format shell scripts by default.
        sh = {},
      },
    },
  },
}
