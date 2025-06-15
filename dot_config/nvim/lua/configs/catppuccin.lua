local safe_require = require("utils").safe_require
local catpuccin = safe_require "catppuccin"
if not catpuccin then
	return
end

catpuccin.setup {
	flavour = "mocha",
	transsparent_background = false,
	integrations = {
		cmp = true,
		blink_cmp = true,
		gitsigns = true,
		grug_far = true,
		indent_blankline = { enabled = true, colored_indent_levels = true },
		mason = true,
		neotree = true,
		notify = true,
		snacks = { enabled = true },
		telescope = { enabled = true },
		treesitter = true,
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
