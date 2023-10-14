return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	"nvim-lua/plenary.nvim", -- Lua functions
	"nvim-lua/popup.nvim", -- Popup API for nvim
	"ray-x/guihua.lua", -- GUI & Util Library
	"MunifTanjim/nui.nvim", -- UI Library
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
	{ "folke/todo-comments.nvim", config = true }, -- Highlight todo comments
	{ "xiyaowong/nvim-transparent", config = true }, -- Add transparency
	{
		"NvChad/nvim-colorizer.lua", -- Colorize rgb codes
		opts = { user_default_options = { names = false } },
	},
	{
		"lewis6991/gitsigns.nvim", -- Git decorations
		opts = { current_line_blame = true, numhl = true, linehl = false },
	},

	-- Treesitter
	-- ------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring", -- Context based commenting
			"windwp/nvim-ts-autotag", -- Autoclose tags
			"drybalka/tree-climber.nvim", -- Tree climber
		},
	},
	{
		"Wansmer/treesj", -- Node splits/joins
		opts = { use_default_keymaps = false },
	},
	{
		"sustech-data/wildfire.nvim", -- Incremental bracket selection
		event = "VeryLazy",
		config = true,
	},

	-- LSP
	-- ------------------------------------------------------------------------
	{
		"williamboman/mason.nvim", -- LSP installer
		build = ":MasonUpdate",
		config = true,
	},
	"williamboman/mason-lspconfig.nvim", -- LSP config helper
	"neovim/nvim-lspconfig", -- LSP config
	"tpope/vim-sleuth", -- Indentation detection
	"pearofducks/ansible-vim", -- Ansible support
	"towolf/vim-helm", -- Helm support
	"mfussenegger/nvim-dap", -- DAP plugins
	"rcarriga/nvim-dap-ui", -- DAP UI
	"theHamsta/nvim-dap-virtual-text", -- DAP virtual text
	"nvim-telescope/telescope-dap.nvim", -- DAP telescope extension
	"stevearc/conform.nvim", -- Formatter
	{ "windwp/nvim-autopairs", config = true }, -- Autoclose Brackets
	{ "smjonas/inc-rename.nvim", config = true }, -- Highlight refactors
	{
		"lukas-reineke/indent-blankline.nvim", -- Indentation guides
		main = "ibl",
		opts = { indent = { char = ">" } },
	},
	{
		"ray-x/lsp_signature.nvim", -- Show signature
		opts = { floating_window = false },
	},

	-- Completion
	-- ------------------------------------------------------------------------
	"L3MON4D3/LuaSnip", -- Snippet engine
	"hrsh7th/nvim-cmp", -- Autocomplete engine
	"hrsh7th/cmp-nvim-lsp", -- LSP completion
	"hrsh7th/cmp-buffer", -- Buffer completion
	"hrsh7th/cmp-path", -- Path completion
	"hrsh7th/cmp-cmdline", -- Cmd completion
	"hrsh7th/cmp-nvim-lua", -- Lua completion
	"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
	"rafamadriz/friendly-snippets", -- Vscode friendly snippets

	-- Extras
	-- ------------------------------------------------------------------------
	"folke/which-key.nvim", -- Key popup
	"machakann/vim-sandwich", -- Surroundings
	"Exafunction/codeium.vim", -- AI completions
	"tpope/vim-repeat", -- Repeat dot
	{ "akinsho/git-conflict.nvim", config = true }, -- Solve git conflicts
	{ "lilibyte/tabhula.nvim", config = true }, -- Tabout context
	{ "lukas-reineke/headlines.nvim", config = true }, -- Markdown highlights
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
		config = true,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ":lua require(\"go.install\").update_all_sync()",
	},
	{
		"max397574/better-escape.nvim", -- Smooth escaping
		opts = { mapping = { "qq" }, keys = "<Esc>", clear_empty_lines = true },
	},
	{
		"johmsalas/text-case.nvim", -- Change text casing
		opts = { prefix = "t" },
	},
	{
		"numToStr/Comment.nvim", -- Smart commenting
		opts = { padding = false, mappings = { basic = false, extra = false } },
	},
	{
		"iamcco/markdown-preview.nvim", -- Live Markdown preview
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
