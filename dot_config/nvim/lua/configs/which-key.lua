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
	{ "<leader>g", group = "Git/Go", nowait = false, remap = false },
	{ "<leader>l", group = "LSP", nowait = false, remap = false },
	{ "<leader>s", group = "Sort", mode = "v", nowait = false, remap = false },
	{ "<leader>p", group = "Paste", nowait = false, remap = false },
	{ "<leader>w", group = "Workspace", nowait = false, remap = false },
	{ "<leader>y", group = "Clipboard", nowait = false, remap = false },
}
