local status_ok, catpuccin = pcall(require, "catpuccin")
if not status_ok then
	return
end

catpuccin.setup {
	flavour = "macchiato",
	transparent_background = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		treesitter = true,
		notify = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = false,
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
