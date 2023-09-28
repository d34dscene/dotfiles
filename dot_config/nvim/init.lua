-- Main
require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.lazy"
require "user.theme"

-- Plugin Configs
require "configs.alpha"
require "configs.treesitter"
require "configs.telescope"
require "configs.neotree"
require "configs.bufferline"
require "configs.lualine"
require "configs.toggleterm"
require "configs.indent-line"
require "configs.which-key"
require "configs.cmp"

-- LSP Configs
require "configs.lspconfig"
require "configs.null-ls"

-- Load theme
vim.cmd.colorscheme "catppuccin"