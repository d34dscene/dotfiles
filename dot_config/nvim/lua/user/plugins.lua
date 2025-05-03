return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	{ "nvim-lua/plenary.nvim", lazy = true }, -- Lua functions
	{ "ray-x/guihua.lua", lazy = true }, -- GUI & Util Library
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
	{
		"xiyaowong/nvim-transparent", -- Transparency
		event = "VimEnter",
		opts = {
			extra_groups = {
				"NormalFloat",
				"NeoTreeNormal",
				"NeoTreeNormalNC",
			},
		},
	},
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		opts = { transparency_color = "#1e1e2e" },
	},

	-- Treesitter
	-- ------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require "nvim-treesitter.query_predicates"
		end,
		dependencies = {
			"windwp/nvim-ts-autotag",
			"windwp/nvim-autopairs",
		},
	},
	{
		"Wansmer/treesj", -- Node splits/joins
		event = "BufReadPost",
		opts = { use_default_keymaps = false },
	},

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
		dependencies = { "hrsh7th/cmp-emoji", "chrisgrieser/cmp-nerdfont" },
	},
	{ "saghen/blink.compat", lazy = true },
	{
		"L3MON4D3/LuaSnip",
		build = vim.fn.has "win32" ~= 0 and "make install_jsregexp" or nil,
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function(_, opts)
			if opts then
				require("luasnip").config.setup(opts)
			end
			vim.tbl_map(function(type)
				require("luasnip.loaders.from_" .. type).lazy_load()
			end, { "vscode", "snipmate", "lua" })
		end,
	},

	-- Extras
	-- ------------------------------------------------------------------------
	{ "folke/which-key.nvim", event = "VeryLazy" }, -- Keybindings helper
	{ "Exafunction/windsurf.vim", event = "InsertEnter" }, -- AI completions
	{ "olimorris/codecompanion.nvim", event = "VeryLazy", config = true }, -- AI chat
	{ "kylechui/nvim-surround", event = "VeryLazy", config = true }, -- Surrounding
	{ "akinsho/git-conflict.nvim", event = "BufReadPost", config = true }, -- Solve git conflicts
	{ "johmsalas/text-case.nvim", event = "VeryLazy", opts = { prefix = "tr" } }, -- Change text casing
	{ "numToStr/Comment.nvim", event = "VeryLazy", opts = { mappings = false } }, -- Smart commenting
	{ "MagicDuck/grug-far.nvim", config = true },
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
