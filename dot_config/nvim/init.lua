vim.loader.enable()

-- Main
require "user.lazy"
require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.theme"

-- Plugin Configs
require "configs.alpha"
<<<<<<< HEAD
require "configs.bufferline"
=======
>>>>>>> 9879dcc (Update .config/nvim/init.lua)
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
