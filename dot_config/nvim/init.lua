vim.loader.enable()

-- Main
require "user.lazy"
require "user.options"
require "user.keymaps"
require "user.autocmds"

-- Plugin Configs
require "configs.blink"
require "configs.catppuccin"
require "configs.codecompanion"
require "configs.conform"
require "configs.lspconfig"
require "configs.lualine"
require "configs.mini"
require "configs.neotree"
require "configs.snacks"
require "configs.treesitter"
require "configs.which-key"

-- Load theme
vim.cmd.colorscheme "catppuccin"
