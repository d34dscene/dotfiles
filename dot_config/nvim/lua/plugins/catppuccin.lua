local ok, catpuccin = pcall(require, "catppuccin")
if not ok then
	vim.notify("Failed to load catppuccin", vim.log.levels.ERROR)
	return nil
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
		mini = { enabled = true, indentscope_color = "" },
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
