return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	"nvim-lua/plenary.nvim", -- Lua functions
	"nvim-lua/popup.nvim", -- Popup API for nvim
	"ray-x/guihua.lua", -- GUI & Util Library
	"3rd/image.nvim", -- Image preview
	"MunifTanjim/nui.nvim", -- UI Library
	"stevearc/dressing.nvim", -- UI hooks
	"akinsho/bufferline.nvim", -- Bufferline
	"nvim-lualine/lualine.nvim", -- Statusline
	"akinsho/nvim-toggleterm.lua", -- Floating terminal
	"nvim-telescope/telescope.nvim", -- File search
	"nvim-tree/nvim-web-devicons", -- Icon support
	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }, -- File explorer
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fuzzy finder

	-- Design
	-- ------------------------------------------------------------------------
	"goolord/alpha-nvim", -- Dashboard
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Main Theme
	{ "brenoprata10/nvim-highlight-colors", config = true }, -- Highlight colors
	{ "folke/todo-comments.nvim", config = true }, -- Highlight todo comments
	{ "lewis6991/gitsigns.nvim", config = true }, -- Git signs
	{ "folke/trouble.nvim", config = true }, -- Quickfix list
	{ "xiyaowong/nvim-transparent", config = true }, -- Add transparency
	{
		"j-hui/fidget.nvim", -- LSP progress
		opts = {
			notification = {
				override_vim_notify = true,
				window = { winblend = 0 },
			},
		},
	},

	-- Treesitter
	-- ------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag", -- Autoclose tags
		},
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", config = true }, -- Context based commenting
	{ "sustech-data/wildfire.nvim", config = true }, -- Incremental bracket selection
	{ "Wansmer/treesj", opts = { use_default_keymaps = false } }, -- Node splits/joins

	-- LSP
	-- ------------------------------------------------------------------------
	{
		"williamboman/mason.nvim", -- LSP installer
		build = ":MasonUpdate",
		config = true,
	},
	{ "williamboman/mason-lspconfig.nvim", config = true }, -- LSP config helper
	"WhoIsSethDaniel/mason-tool-installer.nvim", -- LSP tool installer
	"neovim/nvim-lspconfig", -- LSP config
	"stevearc/conform.nvim", -- Formatter
	"tpope/vim-sleuth", -- Indentation detection
	"towolf/vim-helm", -- Helm support
	"pearofducks/ansible-vim", -- Ansible support
	"mfussenegger/nvim-dap", -- DAP plugins
	"rcarriga/nvim-dap-ui", -- DAP UI
	"theHamsta/nvim-dap-virtual-text", -- DAP virtual text
	{ "aznhe21/actions-preview.nvim", config = true }, -- Code actions preview
	{ "windwp/nvim-autopairs", config = true }, -- Autoclose Brackets
	{ "smjonas/inc-rename.nvim", config = true }, -- Highlight refactors
	{
		"lukas-reineke/indent-blankline.nvim", -- Indentation guides
		main = "ibl",
		opts = { indent = { char = ">" } },
	},
	{
		"ray-x/lsp_signature.nvim", -- Show signature
		event = "VeryLazy",
		opts = { floating_window = false },
	},

	-- Completion
	-- ------------------------------------------------------------------------
	"L3MON4D3/LuaSnip", -- Snippet engine
	-- "hrsh7th/nvim-cmp", -- Autocomplete engine
	-- "hrsh7th/cmp-nvim-lsp", -- LSP completion
	-- "hrsh7th/cmp-buffer", -- Buffer completion
	"hrsh7th/cmp-path", -- Path completion
	-- "hrsh7th/cmp-cmdline", -- Cmd completion
	-- "hrsh7th/cmp-nvim-lua", -- Lua completion
	"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
	"rafamadriz/friendly-snippets", -- Vscode friendly snippets
	-- Testing cmp fork
	{ "iguanacucumber/magazine.nvim", name = "nvim-cmp" },
	{ "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
	{ "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
	{ "iguanacucumber/mag-buffer", name = "cmp-buffer" },
	{ "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
	"https://codeberg.org/FelipeLema/cmp-async-path",

	-- Extras
	-- ------------------------------------------------------------------------
	"folke/which-key.nvim", -- Key popup
	"tpope/vim-repeat", -- Repeat dot
	"nomnivore/ollama.nvim", -- Ollama
	"Exafunction/codeium.vim", -- AI completions
	{ "kylechui/nvim-surround", config = true }, -- Surrounding
	{ "akinsho/git-conflict.nvim", config = true }, -- Solve git conflicts
	{ "max397574/better-escape.nvim", config = true }, -- Fast escape
	{ "johmsalas/text-case.nvim", opts = { prefix = "t" } }, -- Change text casing
	{ "numToStr/Comment.nvim", opts = { mappings = false } }, -- Smart commenting
	-- {
	-- 	"supermaven-inc/supermaven-nvim", -- AI completions
	-- 	opts = {
	-- 		keymaps = {
	-- 			accept_suggestion = "<M-f>",
	-- 			clear_suggestion = "<M-d>",
	-- 			accept_word = "<M-a>",
	-- 		},
	-- 	},
	-- },
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
