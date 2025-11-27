vim.loader.enable()

-- Main
require "user.lazy"
require "user.options"
require "user.keymaps"
require "user.autocmds"

-- Plugin Configs
require "plugins.lsp"
require "plugins.blink"
require "plugins.diagnostic"
require "plugins.catppuccin"
require "plugins.codecompanion"
require "plugins.conform"
require "plugins.lualine"
require "plugins.mini"
require "plugins.neotree"
require "plugins.snacks"
require "plugins.treesitter"
require "plugins.which-key"

-- Load theme
vim.cmd.colorscheme "catppuccin"
