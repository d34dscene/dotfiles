return {
	-- Main plugins
	-- ------------------------------------------------------------------------
	"nvim-lua/popup.nvim", -- Popup API from vim in Neovim
	"nvim-lua/plenary.nvim", -- Lua functions
	"akinsho/bufferline.nvim", -- Bufferline
	"MunifTanjim/nui.nvim", -- UI Library
	"akinsho/nvim-toggleterm.lua", -- Floating terminal
	"nvim-telescope/telescope.nvim", -- File search
	{ -- File explorer
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
	},

	-- Design
	-- ------------------------------------------------------------------------
	"goolord/alpha-nvim", -- Dashboard
	"nvim-lualine/lualine.nvim", -- Statusline
	"norcalli/nvim-colorizer.lua", -- Colorize rgb codes
	"onsails/lspkind.nvim", -- Vscode-like pictograms
	{ -- Theme
		"catppuccin/nvim",
		name = "catppuccin",
	},
	{ -- Add transparency
		"xiyaowong/nvim-transparent",
		config = function()
			require("transparent").setup { enable = true }
		end,
	},
	{ -- Icons
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup { default = true }
		end,
	},
	{ -- Pretty notifications
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup {
				background_colour = "#000000",
				render = "minimal",
				top_down = false,
			}
			vim.notify = require "notify"
		end,
	},
	{ -- Winbar
		"utilyre/barbecue.nvim",
		config = function()
			require("barbecue").setup {
				attach_navic = false,
				symbols = {
					separator = "",
				},
				theme = "catppuccin",
			}
		end,
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ -- Git decorations
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup {
				current_line_blame = true,
				numhl = true,
				linehl = false,
			}
		end,
	},
	{ -- Follow cursor
		"gen740/SmoothCursor.nvim",
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
	{ -- Parenthesis highlighting
		"mrjones2014/nvim-ts-rainbow",
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
	{ -- Show signature
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup {
				floating_window = false,
				handler_opts = {
					border = "none",
				},
			}
		end,
	},
	{ -- Highlight refactors
		"smjonas/inc-rename.nvim",
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
	"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
	"rafamadriz/friendly-snippets", -- Vscode friendly snippets

	-- Extras
	-- ------------------------------------------------------------------------
	"max397574/better-escape.nvim", -- Smooth escaping
	"folke/which-key.nvim", -- Key popup
	"haya14busa/is.vim", -- Auto clear highlight
	"gelguy/wilder.nvim", -- Search suggestions
	"machakann/vim-sandwich", -- Surroundings
	{ -- Code outline
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup {}
		end,
	},
	{ -- Tabout from different contexts
		"abecodes/tabout.nvim",
		config = function()
			require("tabout").setup {
				ignore_beginning = false,
			}
		end,
	},
	{ -- Highlight todo comments
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup {}
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ -- Change text casing
		"johmsalas/text-case.nvim",
		config = function()
			require("textcase").setup {
				prefix = "t",
			}
		end,
	},
	{ -- Folding
		"kevinhwang91/nvim-ufo",
		config = function()
			require("ufo").setup {}
		end,
		dependencies = { "kevinhwang91/promise-async" },
	},
	{ -- Smart commenting
		"numToStr/Comment.nvim",
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
	{ -- Diagnostics
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup {
				auto_open = false,
				use_diagnostic_signs = true,
			}
		end,
	},
	{ -- Generate docs
		"danymat/neogen",
		config = function()
			require("neogen").setup {
				snippet_engine = "luasnip",
			}
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{ -- Better quick escape
		"jdhao/better-escape.vim",
		event = "InsertEnter",
	},
	{ -- Live Markdown preview
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	"Exafunction/codeium.vim", -- Codium
	{ -- Codium cmp integration
		"jcdickinson/codeium.nvim",
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
