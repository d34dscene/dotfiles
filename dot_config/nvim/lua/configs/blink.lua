local status_ok, blink = pcall(require, "blink.cmp")
if not status_ok then
	return
end

blink.setup {
	keymap = {
		preset = "enter",
		["<Tab>"] = {
			function(cmp)
				if not cmp.snippet_active() then
					return cmp.select_next()
				end
			end,
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				if not cmp.snippet_active() then
					return cmp.select_prev()
				end
			end,
			"snippet_backward",
			"fallback",
		},
		cmdline = {
			preset = "super-tab",
		},
	},
	appearance = {
		use_nvim_cmp_as_default = true, -- will be removed
		nerd_font_variant = "mono",
	},
	path = {
		opts = {
			show_hidden_files_by_default = true,
		},
	},
	completion = {
		documentation = {
			auto_show = true,
		},
	},
	signature = {
		enabled = true,
	},
	sources = {
		completion = {
			enabled_providers = { "lsp", "path", "snippets", "buffer", "nerdfont", "emoji" },
		},
		providers = {
			nerdfont = { name = "nerdfont", module = "blink.compat.source" },
			emoji = { name = "emoji", module = "blink.compat.source" },
			snippets = { opts = { global_snippets = {} } },
		},
	},
}
