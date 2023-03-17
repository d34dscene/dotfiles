return {
	-- Main plugins
	-- ------------------------------------------------------------------------
	"nvim-lua/popup.nvim", -- Popup API from vim in Neovim
	"nvim-lua/plenary.nvim", -- Lua functions
	"akinsho/bufferline.nvim", -- Bufferline
	"MunifTanjim/nui.nvim", -- UI Library
	"akinsho/nvim-toggleterm.lua", -- Floating terminal
	"nvim-telescope/telescope.nvim", -- File search
	{
		"nvim-neo-tree/neo-tree.nvim", -- File explorer
		branch = "v2.x",
	},

	-- Design
	-- ------------------------------------------------------------------------
	"goolord/alpha-nvim", -- Dashboard
	"nvim-lualine/lualine.nvim", -- Statusline
	"onsails/lspkind.nvim", -- Vscode-like pictograms
	"SmiteshP/nvim-navic", -- Navic
	{
		"norcalli/nvim-colorizer.lua", -- Colorize rgb codes
		config = function()
			require("colorizer").setup({ "*" }, { mode = "background" })
		end,
	},
	{
		"catppuccin/nvim", -- Theme
		name = "catppuccin",
	},
	{
		"xiyaowong/nvim-transparent", -- Add transparency
		config = function()
			require("transparent").setup { enable = true }
		end,
	},
	{
		"nvim-tree/nvim-web-devicons", -- Icons
		config = function()
			require("nvim-web-devicons").setup { default = true }
		end,
	},
	{
		"rcarriga/nvim-notify", -- Pretty notifications
		config = function()
			require("notify").setup {
				background_colour = "#000000",
				render = "minimal",
				top_down = false,
			}
			vim.notify = require "notify"
		end,
	},
	{
		"utilyre/barbecue.nvim", -- Winbar
		config = function()
			require("barbecue").setup {
				attach_navic = false,
				symbols = {
					separator = "",
				},
				theme = "catppuccin",
			}
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
	{
		"gen740/SmoothCursor.nvim", -- Follow cursor
		config = function()
			require("smoothcursor").setup {}
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
	{
		"mrjones2014/nvim-ts-rainbow", -- Parenthesis highlighting
		config = function()
			require("nvim-treesitter.configs").setup {
				rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = nil,
				},
			}
		end,
	},
	{
		"Wansmer/treesj", -- Node splits/joins
		config = function()
			require("treesj").setup { use_default_keymaps = false }
		end,
	},

	-- LSP
	-- ------------------------------------------------------------------------
	"williamboman/mason.nvim", -- LSP installer
	"williamboman/mason-lspconfig.nvim", -- LSP config helper
	"jayp0521/mason-null-ls.nvim", -- Null-ls helper
	"neovim/nvim-lspconfig", -- LSP config
	"tpope/vim-sleuth", -- Indentation detection
	"lukas-reineke/indent-blankline.nvim", -- Indentation guides
	"windwp/nvim-autopairs", -- Autoclose Brackets
	"jose-elias-alvarez/null-ls.nvim", -- LSP hooks
	"jose-elias-alvarez/typescript.nvim", -- Typescript features
	"pearofducks/ansible-vim", -- Ansible support
	"towolf/vim-helm", -- Helm support
	"b0o/schemastore.nvim", -- JSON schemas
	{
		"ray-x/lsp_signature.nvim", -- Show signature
		config = function()
			require("lsp_signature").setup {
				floating_window = false,
				handler_opts = {
					border = "none",
				},
			}
		end,
	},
	{
		"smjonas/inc-rename.nvim", -- Highlight refactors
		config = function()
			require("inc_rename").setup {}
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
		"stevearc/aerial.nvim", -- Code outline
		config = function()
			require("aerial").setup {}
		end,
	},
	{
		"abecodes/tabout.nvim", -- Tabout from different contexts
		config = function()
			require("tabout").setup {
				ignore_beginning = false,
			}
		end,
	},
	{
		"folke/todo-comments.nvim", -- Highlight todo comments
		config = function()
			require("todo-comments").setup {}
		end,
	},
	{
		"johmsalas/text-case.nvim", -- Change text casing
		config = function()
			require("textcase").setup {
				prefix = "t",
			}
		end,
	},
	{
		"kevinhwang91/nvim-ufo", -- Folding
		config = function()
			require("ufo").setup {}
		end,
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
		"folke/trouble.nvim", -- Diagnostics
		config = function()
			require("trouble").setup {
				auto_open = false,
				use_diagnostic_signs = true,
			}
		end,
	},
	{
		"danymat/neogen", -- Generate docs
		config = function()
			require("neogen").setup {
				snippet_engine = "luasnip",
			}
		end,
	},
	{
		"iamcco/markdown-preview.nvim", -- Live Markdown preview
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"jcdickinson/codeium.nvim", -- Codium cmp integration
		config = function()
			require("codeium").setup {}
		end,
	},
	-- { -- ChatGPT
	-- 	"jackMort/ChatGPT.nvim",
	-- 	config = function()
	-- 		require("chatgpt").setup {}
	-- 	end,
	-- },
}
