return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	"nvim-lua/plenary.nvim", -- Lua functions
	"ray-x/guihua.lua", -- GUI & Util Library
	"MunifTanjim/nui.nvim", -- UI Library
	"stevearc/dressing.nvim", -- UI hooks
	"akinsho/bufferline.nvim", -- Bufferline
	"nvim-lualine/lualine.nvim", -- Statusline
	"nvim-telescope/telescope.nvim", -- File search
	"nvim-tree/nvim-web-devicons", -- Icon support
	{ "chrisgrieser/nvim-spider", lazy = true }, -- Easy motion
	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }, -- File explorer
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fuzzy finder
	{ "folke/snacks.nvim", priority = 1000, lazy = false }, -- Multiple qol plugins

	-- Design
	-- ------------------------------------------------------------------------
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Main Theme
	{ "brenoprata10/nvim-highlight-colors", config = true }, -- Highlight colors
	{ "folke/todo-comments.nvim", config = true }, -- Highlight todo comments
	{ "lewis6991/gitsigns.nvim", config = true }, -- Git signs
	{ "xiyaowong/nvim-transparent", config = true }, -- Add transparency
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
	{ "sustech-data/wildfire.nvim", event = "VeryLazy", config = true }, -- Incremental bracket selection
	{ "Wansmer/treesj", opts = { use_default_keymaps = false } }, -- Node splits/joins

	-- LSP
	-- ------------------------------------------------------------------------
	{
		"williamboman/mason.nvim", -- LSP installer
		build = ":MasonUpdate",
		config = true,
	},
	{ "williamboman/mason-lspconfig.nvim", config = true }, -- LSP config helper
	"neovim/nvim-lspconfig", -- LSP config
	"stevearc/conform.nvim", -- Formatter
	"mfussenegger/nvim-ansible", -- Ansible support
	{ "smjonas/inc-rename.nvim", config = true }, -- Highlight refactors
	{ "pmizio/typescript-tools.nvim", config = true }, -- Typescript tools

	-- Completion
	-- ------------------------------------------------------------------------
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			-- "rafamadriz/friendly-snippets",
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"hrsh7th/cmp-emoji",
			"chrisgrieser/cmp-nerdfont",
		},
	},
	{ "saghen/blink.compat", lazy = true },

	-- Extras
	-- ------------------------------------------------------------------------
	"folke/which-key.nvim", -- Key popup
	"tpope/vim-repeat", -- Repeat dot
	"Exafunction/codeium.vim", -- AI completions
	{ "olimorris/codecompanion.nvim", event = "VeryLazy", config = true }, -- AI completions
	{ "kylechui/nvim-surround", config = true }, -- Surrounding
	{ "akinsho/git-conflict.nvim", config = true }, -- Solve git conflicts
	{ "johmsalas/text-case.nvim", opts = { prefix = "t" } }, -- Change text casing
	{ "numToStr/Comment.nvim", opts = { mappings = false } }, -- Smart commenting
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
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
