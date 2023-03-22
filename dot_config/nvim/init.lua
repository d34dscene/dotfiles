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
require "configs.autopairs"
require "configs.wilder"
require "configs.cmp"

-- LSP Configs
require "configs.lsp.mason"
require "configs.lsp.mason-null-ls"
require "configs.lsp.mason-lspconfig"
require "configs.lsp.null-ls"

-- Load theme
vim.cmd.colorscheme "catppuccin"
