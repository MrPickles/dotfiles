return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyrefly = {
          init_options = {
            pyrefly = {
              typeCheckingMode = "default",
            },
          },
        },
      },
    },
  },
}
