-- Load Impatient before anything else.
-- Since this may fail if we're bootstrapping, we use a pcall.
pcall(require, 'impatient')

require('plugins')
require('settings')
require('keybindings')
