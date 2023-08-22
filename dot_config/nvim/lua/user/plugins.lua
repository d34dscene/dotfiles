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
	"onsails/lspkind.nvim", -- Vscode-like pictograms
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Main Theme
	{ "folke/todo-comments.nvim", config = true }, -- Highlight todo comments
	{ "xiyaowong/nvim-transparent", config = true }, -- Add transparency
	{
		"norcalli/nvim-colorizer.lua", -- Colorize rgb codes
		config = function()
			require("colorizer").setup({ "*" }, { mode = "background" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim", -- Git decorations
		config = function()
			require("gitsigns").setup {
				current_line_blame = true,
				numhl = true,
				linehl = false,
			}
		end,
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
		config = function()
			require("treesj").setup { use_default_keymaps = false }
		end,
	},
	{
		"sustech-data/wildfire.nvim", -- Incremental bracket selection
		event = "VeryLazy",
		config = true,
	},

	-- LSP
	-- ------------------------------------------------------------------------
	{ -- LSP installer
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{ "jayp0521/mason-null-ls.nvim", config = true }, -- Null-ls helper
	"williamboman/mason-lspconfig.nvim", -- LSP config helper
	"neovim/nvim-lspconfig", -- LSP config
	"tpope/vim-sleuth", -- Indentation detection
	"lukas-reineke/indent-blankline.nvim", -- Indentation guides
	"jose-elias-alvarez/null-ls.nvim", -- LSP hooks
	"jose-elias-alvarez/typescript.nvim", -- Typescript features
	"pearofducks/ansible-vim", -- Ansible support
	"towolf/vim-helm", -- Helm support
	"b0o/schemastore.nvim", -- JSON schemas
	"mfussenegger/nvim-dap", -- DAP plugins
	"rcarriga/nvim-dap-ui", -- DAP UI
	"theHamsta/nvim-dap-virtual-text", -- DAP virtual text
	"nvim-telescope/telescope-dap.nvim", -- DAP telescope extension
	{ "windwp/nvim-autopairs", config = true }, -- Autoclose Brackets
	{ "smjonas/inc-rename.nvim", config = true }, -- Highlight refactors
	{
		"ray-x/lsp_signature.nvim", -- Show signature
		config = function()
			require("lsp_signature").setup { floating_window = false }
		end,
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
	"haya14busa/is.vim", -- Auto clear highlight
	"gelguy/wilder.nvim", -- Search suggestions
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
				search = {
					enabled = false,
				},
				char = {
					keys = { ["f"] = "F", ["t"] = "T" },
				},
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
		config = function()
			require("better_escape").setup {
				mapping = { "qq" },
				keys = "<Esc>",
			}
		end,
	},
	{
		"johmsalas/text-case.nvim", -- Change text casing
		config = function()
			require("textcase").setup { prefix = "t" }
		end,
	},
	{
		"kevinhwang91/nvim-ufo", -- Better folding
		config = true,
		dependencies = { "kevinhwang91/promise-async" },
	},
	{
		"numToStr/Comment.nvim", -- Smart commenting
		config = function()
			require("Comment").setup {
				padding = true,
				mappings = {
					basic = false,
					extra = false,
				},
			}
		end,
	},
	{
		"iamcco/markdown-preview.nvim", -- Live Markdown preview
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
