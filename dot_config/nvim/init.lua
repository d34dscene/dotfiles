vim.loader.enable()

-- Main
require "user.lazy"
require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.theme"

-- Plugin Configs
require "configs.alpha"
require "configs.bufferline"
require "configs.blink"
require "configs.bufferline"
require "configs.codecompanion"
require "configs.conform"
require "configs.lspconfig"
require "configs.lualine"
require "configs.neotree"
require "configs.telescope"
require "configs.toggleterm"
require "configs.treesitter"
require "configs.which-key"

-- Load theme
vim.cmd.colorscheme "catppuccin"
