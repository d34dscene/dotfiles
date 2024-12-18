local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

which_key.setup {
	icons = { mappings = false },
	plugins = {
		spelling = { enabled = true },
		presets = { operators = false },
	},
}

which_key.add {
	{ "<leader>c", group = "Code Actions", nowait = false, remap = false },
	{ "<leader>f", group = "File", nowait = false, remap = false },
	{ "<leader>g", group = "Go", nowait = false, remap = false },
	{ "<leader>l", group = "LSP", nowait = false, remap = false },
	{ "<leader>r", group = "Replace", nowait = false, remap = false },
	{ "<leader>x", group = "Trouble", nowait = false, remap = false },
	{ "<leader>s", group = "Sort", mode = "v", nowait = false, remap = false },
	{ "<leader>c", group = "CodeCompanion", nowait = false, remap = false },
	{ "<leader>y", group = "Clipboard", nowait = false, remap = false },
}
