require('bufferline').setup {
  options = {
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        text_align = 'center',
      },
    },
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level, _, _)
      local icon = level:match('error') and ' ' or ' '
      return " "..icon..count
    end,
    show_close_icon = false,
    show_tab_indicators = true,
  },
}
