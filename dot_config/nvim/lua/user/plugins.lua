return {
	-- Important plugins
	-- ------------------------------------------------------------------------
	"nvim-lua/popup.nvim", -- Popup API from vim in Neovim
	"nvim-lua/plenary.nvim", -- Lua functions
	"MunifTanjim/nui.nvim", -- UI Library
	"akinsho/bufferline.nvim", -- Bufferline
	"akinsho/nvim-toggleterm.lua", -- Floating terminal
	"nvim-telescope/telescope.nvim", -- File search
	{
		"nvim-neo-tree/neo-tree.nvim", -- File explorer
		branch = "v2.x",
	},

	-- Design
	-- ------------------------------------------------------------------------
	"goolord/alpha-nvim", -- Dashboard
	"nvim-tree/nvim-web-devicons", -- Icons
	"nvim-lualine/lualine.nvim", -- Statusline
	"onsails/lspkind.nvim", -- Vscode-like pictograms
	"folke/zen-mode.nvim", -- Zen mode
	{
		"catppuccin/nvim", -- Main Theme
		name = "catppuccin",
	},
	{
		"folke/todo-comments.nvim", -- Highlight todo comments
		config = true,
	},
	{
		"xiyaowong/nvim-transparent", -- Add transparency
		config = true,
	},
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
	},
	"JoosepAlviste/nvim-ts-context-commentstring", -- Context based commenting
	"windwp/nvim-ts-autotag", -- Autoclose tags
	"HiPhish/nvim-ts-rainbow2", -- Rainbow highlighting
	{
		"Wansmer/treesj", -- Node splits/joins
		config = function()
			require("treesj").setup { use_default_keymaps = false }
		end,
	},

	-- LSP
	-- ------------------------------------------------------------------------
	{ -- LSP installer
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{ -- Null-ls helper
		"jayp0521/mason-null-ls.nvim",
		config = true,
	},
	"williamboman/mason-lspconfig.nvim", -- LSP config helper
	"neovim/nvim-lspconfig", -- LSP config
	"tpope/vim-sleuth", -- Indentation detection
	{
		"lukas-reineke/indent-blankline.nvim", -- Indentation guides
		version = "2.20.7",
	},
	"jose-elias-alvarez/null-ls.nvim", -- LSP hooks
	"jose-elias-alvarez/typescript.nvim", -- Typescript features
	"pearofducks/ansible-vim", -- Ansible support
	"towolf/vim-helm", -- Helm support
	"b0o/schemastore.nvim", -- JSON schemas
	{
		"windwp/nvim-autopairs", -- Autoclose Brackets
		config = true,
	},
	{
		"ray-x/lsp_signature.nvim", -- Show signature
		config = function()
			require("lsp_signature").setup { floating_window = false }
		end,
	},
	{
		"smjonas/inc-rename.nvim", -- Highlight refactors
		config = true,
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
	{
		"akinsho/git-conflict.nvim", -- Solve git conflicts
		config = true,
	},
	{
		"lilibyte/tabhula.nvim", -- Tabout context
		config = true,
	},
	{
		"ray-x/go.nvim", -- Lots of go tools
		config = true,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ":lua require(\"go.install\").update_all_sync()",
	},
	{
		"ggandor/leap.nvim", -- Leap motion
		config = true,
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
