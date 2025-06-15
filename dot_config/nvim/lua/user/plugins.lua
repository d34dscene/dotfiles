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
	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }, -- File explorer
	{ "folke/snacks.nvim", priority = 1000, lazy = false }, -- Multiple qol plugins

	-- Design
	-- ------------------------------------------------------------------------
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Main Theme
	{ "brenoprata10/nvim-highlight-colors", event = "BufReadPost", config = true }, -- Highlight colors
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true }, -- Git signs
	{
		"folke/todo-comments.nvim", -- Highlight todo comments
		event = "BufReadPost",
		config = true,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo",
			},
		},
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
		keys = {
			{
				"tt",
				function()
					require("treesj").toggle()
				end,
				desc = "Toggle node under cursor",
			},
		},
	},

	-- LSP
	-- ------------------------------------------------------------------------
	{
		"williamboman/mason.nvim", -- LSP installer
		build = ":MasonUpdate",
		config = true,
		keys = {
			{ "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
			{ "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
			{ "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP info" },
		},
	},
	"b0o/schemastore.nvim", -- Schema store
	{ "williamboman/mason-lspconfig.nvim", event = "BufReadPost" },
	{ "neovim/nvim-lspconfig", event = "BufReadPost" }, -- LSP config
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
	"mfussenegger/nvim-ansible", -- Ansible support
	{
		"stevearc/conform.nvim", -- Formatter
		event = "BufReadPost",
		keys = {
			{ "<leader>lf", "<cmd>ConformInfo<cr>", desc = "Conform info" },
		},
	},

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
		dependencies = {
			"rafamadriz/friendly-snippets",
			"benfowler/telescope-luasnip.nvim",
		},
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
	{ "olimorris/codecompanion.nvim", event = "VeryLazy", config = true }, -- AI chat
	{ "kylechui/nvim-surround", event = "VeryLazy", config = true }, -- Surrounding
	{ "johmsalas/text-case.nvim", event = "VeryLazy", opts = { prefix = "tr" } }, -- Change text casing
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
		"numToStr/Comment.nvim", -- Smart commenting
		event = "VeryLazy",
		opts = { mappings = false },
		keys = {
			{
				"x",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Comment line",
			},
			{
				"x",
				mode = { "v" },
				function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
					require("Comment.api").toggle.linewise(vim.fn.visualmode())
				end,
				desc = "Comment block",
			},
		},
	},
	{
		"chrisgrieser/nvim-spider", -- Easy motion
		lazy = true,
		keys = {
			{
				"w",
				mode = { "n", "x", "o" },
				function()
					require("spider").motion "w"
				end,
				desc = "Spider W",
			},
			{
				"e",
				mode = { "n", "x", "o" },
				function()
					require("spider").motion "e"
				end,
				desc = "Spider E",
			},
			{
				"b",
				mode = { "n", "x", "o" },
				function()
					require("spider").motion "b"
				end,
				desc = "Spider B",
			},
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
		"supermaven-inc/supermaven-nvim", -- AI completion
		event = "VeryLazy",
		opts = {
			keymaps = { accept_suggestion = "<A-f>" },
		},
		dependencies = { "huijiro/blink-cmp-supermaven" },
	},
	{
		"folke/flash.nvim", -- Jump around
		event = "VeryLazy",
		opts = {
			modes = {
				search = { enabled = false },
				char = { keys = { ["f"] = "F" } },
			},
		},
		keys = {
			{
				"f",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
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
		"iamcco/markdown-preview.nvim", -- Live Markdown preview
		ft = "markdown", -- Load only for markdown files
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{ "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
		},
	},
}
