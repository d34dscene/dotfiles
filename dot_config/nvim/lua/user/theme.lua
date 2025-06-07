local safe_require = require("utils").safe_require
local catpuccin = safe_require "catppuccin"
if not catpuccin then
	return
end

catpuccin.setup {
	flavour = "mocha",
	transparent_background = true,
	integrations = {
		cmp = true,
		blink_cmp = true,
		gitsigns = true,
		treesitter = true,
		notify = true,
		snacks = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
	},
}
