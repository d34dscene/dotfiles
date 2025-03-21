vim.loader.enable()

-- Main
require "user.lazy"
require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.theme"

-- Plugin Configs
require "configs.ai"
require "configs.blink"
require "configs.bufferline"
require "configs.conform"
require "configs.lspconfig"
require "configs.lualine"
require "configs.neotree"
require "configs.snacks"
require "configs.treesitter"
require "configs.which-key"

-- Load theme
vim.cmd.colorscheme "catppuccin"
