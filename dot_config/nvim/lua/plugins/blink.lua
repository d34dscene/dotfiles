local ok, blink = pcall(require, "blink.cmp")
if not ok then
	vim.notify("Failed to load blink", vim.log.levels.ERROR)
	return nil
end

blink.setup {
	keymap = {
		preset = "enter",
		["<Tab>"] = {
			"select_next",
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		trigger = { prefetch_on_insert = false },
		accept = { auto_brackets = { enabled = true } },
		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		ghost_text = { enabled = true },
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind" },
				},
			},
		},
	},
	signature = {
		enabled = true,
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "nerdfont", "minuet" },
		providers = {
			nerdfont = { name = "nerdfont", module = "blink.compat.source" },
			minuet = {
				name = "minuet",
				module = "minuet.blink",
				async = true,
				-- Should match minuet.config.request_timeout * 1000,
				-- since minuet.config.request_timeout is in seconds
				timeout_ms = 3000,
				score_offset = 50, -- Gives minuet higher priority among suggestions
			},
		},
	},
}
