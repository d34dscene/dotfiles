local safe_require = require("utils").safe_require
local blink = safe_require "blink.cmp"
if not blink then
	return
end

blink.setup {
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		ghost_text = {
			enabled = true,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
			},
		},
	},
	signature = {
		enabled = true,
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "codecompanion", "nerdfont", "emoji" },
		providers = {
			nerdfont = { name = "nerdfont", module = "blink.compat.source" },
			emoji = { name = "emoji", module = "blink.compat.source" },
			codecompanion = {
				enabled = true,
				name = "CodeCompanion",
				module = "codecompanion.providers.completion.blink",
			},
		},
	},
}
