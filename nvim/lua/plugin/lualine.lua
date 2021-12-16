local gps = require('nvim-gps')

require('lualine').setup {
  sections = {
    lualine_b = {
      {'branch', icon = ''},
      {
        'filename',
        symbols = {readonly = ' '},
      },
    },
    lualine_c = {
      'diff',
      'diagnostics',
      {gps.get_location, cond = gps.is_available},
    },
  },
}
