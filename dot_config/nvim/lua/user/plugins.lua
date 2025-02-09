return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	{ "nvim-lua/plenary.nvim", lazy = true }, -- Lua functions
	{ "ray-x/guihua.lua", lazy = true }, -- GUI & Util Library
	"nvim-telescope/telescope.nvim", -- File search
	{ "MunifTanjim/nui.nvim", lazy = true }, -- UI Library
	{ "stevearc/dressing.nvim", event = "VeryLazy" }, -- UI hooks
	{ "akinsho/bufferline.nvim", event = "VimEnter" }, -- Bufferline
	{ "nvim-lualine/lualine.nvim", event = "VimEnter" }, -- Statusline
	{ "nvim-tree/nvim-web-devicons", event = "VimEnter" }, -- Icon support
	{ "chrisgrieser/nvim-spider", lazy = true }, -- Easy motion
	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }, -- File explorer
	{ "folke/snacks.nvim", priority = 1000, lazy = false }, -- Multiple qol plugins

	-- Design
	-- ------------------------------------------------------------------------
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Main Theme
	{ "brenoprata10/nvim-highlight-colors", event = "BufReadPost", config = true }, -- Highlight colors
	{ "folke/todo-comments.nvim", event = "BufReadPost", config = true }, -- Highlight todo comments
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true }, -- Git signs
	{ "xiyaowong/nvim-transparent", event = "VimEnter", config = true }, -- Add transparency
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		opts = { transparency_color = "#1e1e2e" },
	},

	-- Treesitter
	-- ------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"windwp/nvim-ts-autotag", -- Autoclose tags
			"windwp/nvim-autopairs", -- Autoclose brackets
		},
	},
	{ "Wansmer/treesj", event = "BufReadPost", opts = { use_default_keymaps = false } }, -- Node splits/joins

	-- LSP
	-- ------------------------------------------------------------------------
	{
		"williamboman/mason.nvim", -- LSP installer
		build = ":MasonUpdate",
		config = true,
	},
	{ "williamboman/mason-lspconfig.nvim", event = "BufReadPost" },
	{ "neovim/nvim-lspconfig", event = "BufReadPost" }, -- LSP config
	{ "stevearc/conform.nvim", event = "BufReadPost" }, -- Formatter
	{ "smjonas/inc-rename.nvim", event = "BufReadPost", config = true }, -- Highlight refactors
	"b0o/schemastore.nvim", -- Schema store
	"mfussenegger/nvim-ansible", -- Ansible support

	-- Completion
	-- ------------------------------------------------------------------------
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"hrsh7th/cmp-emoji",
			"chrisgrieser/cmp-nerdfont",
		},
	},
	{ "saghen/blink.compat", lazy = true },

	-- Extras
	-- ------------------------------------------------------------------------
	{ "folke/which-key.nvim", event = "VeryLazy" }, -- Keybindings helper
	{ "tpope/vim-repeat", event = "VeryLazy" }, -- Repeat commands
	{ "Exafunction/codeium.vim", event = "InsertEnter" }, -- AI completions
	{ "olimorris/codecompanion.nvim", event = "VeryLazy", config = true }, -- AI chat
	{ "kylechui/nvim-surround", event = "VeryLazy", config = true }, -- Surrounding
	{ "akinsho/git-conflict.nvim", event = "BufReadPost", config = true }, -- Solve git conflicts
	{ "johmsalas/text-case.nvim", event = "VeryLazy", opts = { prefix = "t" } }, -- Change text casing
	{ "numToStr/Comment.nvim", event = "VeryLazy", opts = { mappings = false } }, -- Smart commenting
	{
		"folke/flash.nvim", -- Jump around
		event = "VeryLazy",
		opts = {
			modes = {
				search = { enabled = false },
				char = { keys = { ["f"] = "F", ["t"] = "T" } },
			},
		},
	},
	{
		"ray-x/go.nvim", -- Lots of go tools
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ":lua require(\"go.install\").update_all_sync()",
		opts = {
			lsp_inlay_hints = { style = "eol" },
		},
	},
	{
		"alker0/chezmoi.vim", -- Chezmoi syntax highlighting
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},
	{
		"iamcco/markdown-preview.nvim", -- Live Markdown preview
		ft = "markdown", -- Load only for markdown files
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
