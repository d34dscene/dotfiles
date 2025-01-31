local status_ok, blink = pcall(require, "blink.cmp")
if not status_ok then
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
				name = "CodeCompanion",
				module = "codecompanion.providers.completion.blink",
				enabled = true,
			},
		},
	},
}
