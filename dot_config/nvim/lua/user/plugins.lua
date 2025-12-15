return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	{ "nvim-lua/plenary.nvim", lazy = true }, -- Lua functions
	{ "MunifTanjim/nui.nvim", lazy = true }, -- UI Library
	{ "stevearc/dressing.nvim", event = "VeryLazy" }, -- UI hooks
	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }, -- File explorer
	{ "folke/snacks.nvim", priority = 1000, lazy = false }, -- Multiple plugins
	{ "echasnovski/mini.nvim", version = false }, -- Multiple plugins

	-- Design
	-- ------------------------------------------------------------------------
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Main Theme
	{ "nvim-lualine/lualine.nvim", event = "VimEnter" }, -- Statusline
	{ "eero-lehtinen/oklch-color-picker.nvim", event = "VeryLazy", config = true }, -- Highlight colors
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		opts = {
			preset = "minimal",
			options = {
				multilines = {
					enabled = true,
					always_show = true,
				},
				show_all_diags_on_cursorline = true,
			},
		},
	},

	-- Treesitter
	-- ------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		-- event = { "BufReadPost", "BufNewFile" },
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
		end,
	},
	{
		"Wansmer/treesj", -- Splits and joins blocks of code
		opts = { use_default_keymaps = false },
		keys = {
			{ "tt", "<cmd>lua require('treesj').toggle()<cr>", desc = "Treesj" },
		},
	},

	-- LSP
	-- ------------------------------------------------------------------------
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		keys = {
			{ "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
			{ "<leader>lr", "<cmd>LspRestartAll<cr>", desc = "Restart LSP" },
			{ "<leader>ls", "<cmd>LspStatus<cr>", desc = "LSP status" },
			{ "<leader>ld", "<cmd>LspDiagnostics<cr>", desc = "LSP diagnostics" },
			{ "<leader>la", "<cmd>LspCapabilities<cr>", desc = "LSP capabilities" },
		},
	},
	{ "stevearc/conform.nvim", event = "BufReadPost" }, -- Formatter
	{ "b0o/schemastore.nvim" }, -- Schema store
	{ "davidmh/mdx.nvim", event = "BufEnter *.mdx", config = true }, -- MDX support
	{
		"smjonas/inc-rename.nvim", -- Highlight refactors
		event = "BufReadPost",
		config = true,
		keys = {
			{ "rr", ":IncRename ", desc = "Refactor" },
			{
				"re",
				function()
					return ":IncRename " .. vim.fn.expand "<cword>"
				end,
				expr = true,
				desc = "Refactor expand",
			},
		},
	},

	-- Completion
	-- ------------------------------------------------------------------------
	{
		"saghen/blink.cmp", -- Completion engine
		version = "*",
		dependencies = { "saghen/blink.compat", "chrisgrieser/cmp-nerdfont" },
	},
	{
		"L3MON4D3/LuaSnip", -- Snippets
		build = vim.fn.has "win32" ~= 0 and "make install_jsregexp" or nil,
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function(_, opts)
			if opts then
				require("luasnip").config.setup(opts)
			end
			vim.tbl_map(function(type)
				require("luasnip.loaders.from_" .. type).lazy_load()
			end, { "vscode", "snipmate", "lua" })
			require("luasnip").filetype_extend("typescript", { "tsdoc" })
			require("luasnip").filetype_extend("javascript", { "jsdoc" })
			require("luasnip").filetype_extend("lua", { "luadoc" })
			require("luasnip").filetype_extend("python", { "pydoc" })
			require("luasnip").filetype_extend("rust", { "rustdoc" })
			require("luasnip").filetype_extend("cs", { "csharpdoc" })
			require("luasnip").filetype_extend("java", { "javadoc" })
			require("luasnip").filetype_extend("c", { "cdoc" })
			require("luasnip").filetype_extend("cpp", { "cppdoc" })
			require("luasnip").filetype_extend("php", { "phpdoc" })
			require("luasnip").filetype_extend("kotlin", { "kdoc" })
			require("luasnip").filetype_extend("ruby", { "rdoc" })
			require("luasnip").filetype_extend("sh", { "shelldoc" })
		end,
	},

	-- Extras
	-- ------------------------------------------------------------------------
	{ "folke/which-key.nvim", event = "VeryLazy" }, -- Keybindings helper
	{ "olimorris/codecompanion.nvim", event = "VeryLazy", version = "v17.33.0" }, -- AI chat
	{ "johmsalas/text-case.nvim", event = "VeryLazy", opts = { prefix = "tr" } }, -- Change text casing
	{ "folke/todo-comments.nvim", config = true },
	{ "windwp/nvim-autopairs", config = true }, -- Autopairs
	{ "windwp/nvim-ts-autotag", config = true }, -- Autotags
	{
		"MagicDuck/grug-far.nvim", -- Search and Replace
		config = true,
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open { transient = true }
				end,
				desc = "Grug window",
			},
			{
				"<leader>sw",
				function()
					require("grug-far").open {
						transient = true,
						prefills = { search = vim.fn.expand "<cword>" },
					}
				end,
				desc = "Grug replace word",
			},
			{
				"<leader>sv",
				function()
					require("grug-far").with_visual_selection {
						transient = true,
						prefills = { search = vim.fn.expand "%" },
					}
				end,
				desc = "Grug replace selection",
			},
		},
	},
	{
		"monkoose/neocodeium",
		event = "VeryLazy",
		config = function()
			local neocodeium = require "neocodeium"
			neocodeium.setup()
			vim.keymap.set("i", "<A-f>", neocodeium.accept)
		end,
	},
	{
		"chrisgrieser/nvim-spider", -- Easy motion
		lazy = true,
		keys = {
			{ "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
			{ "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
			{ "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
		},
	},
	{
		"akinsho/git-conflict.nvim", -- Solve git conflicts
		event = "BufReadPost",
		config = true,
		keys = {
			{ "<leader>gc", "<cmd>GitConflictListQf<cr>", desc = "Git conflict" },
		},
	},
	{
		"ray-x/go.nvim", -- Lots of go tools
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ":lua require(\"go.install\").update_all_sync()",
		opts = {
			golangci_lint = { default = "fast" },
			lsp_inlay_hints = { enable = true },
			diagnostic = false,
		},
		keys = {
			{ "<leader>gf", "<cmd>GoFillStruct<cr>", desc = "Go fill struct" },
			{ "<leader>ga", "<cmd>GoAddTag<cr>", desc = "Go add tags" },
			{ "<leader>gr", "<cmd>GoRmTag<cr>", desc = "Go remove tags" },
			{ "<leader>gm", "<cmd>GoModTidy<cr>", desc = "Go mod tidy" },
			{ "<leader>gl", "<cmd>GoLint<cr>", desc = "Go lint" },
			{ "<leader>gt", "<cmd>GoAddAllTest -bench<cr>", desc = "Go add tests" },
			{ "<leader>gv", "<cmd>GoCoverage<cr>", desc = "Go coverage" },
		},
	},
	{
		"alker0/chezmoi.vim", -- Chezmoi syntax highlighting
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},
	{
		"brianhuster/live-preview.nvim", -- Live Markdown preview
		keys = {
			{ "<leader>ms", "<cmd>LivePreview start<cr>", desc = "Markdown Preview Start" },
			{ "<leader>mc", "<cmd>LivePreview close<cr>", desc = "Markdown Preview Close" },
		},
	},
}
