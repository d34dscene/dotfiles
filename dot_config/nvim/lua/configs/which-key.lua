local ok, which_key = pcall(require, "which-key")
if not ok then
	vim.notify("Failed to load which-key", vim.log.levels.ERROR)
	return nil
end

which_key.setup {
	icons = { mappings = false },
	plugins = {
		spelling = { enabled = true },
		presets = { operators = false },
	},
}

which_key.add {
	{ "<leader>c", group = "Code Actions", mode = { "n", "v" }, nowait = false, remap = false },
	{ "<leader>f", group = "File", nowait = false, remap = false },
	{ "<leader>g", group = "Git/Go", nowait = false, remap = false },
	{ "<leader>l", group = "LSP", nowait = false, remap = false },
	{ "<leader>s", group = "Sort", mode = "v", nowait = false, remap = false },
	{ "<leader>s", group = "Search", mode = "n", nowait = false, remap = false },
	{ "<leader>p", group = "Paste", nowait = false, remap = false },
	{ "<leader>t", group = "Typescript", nowait = false, remap = false },
	{ "<leader>m", group = "Markdown", nowait = false, remap = false },
	{ "<leader>w", group = "Workspace", nowait = false, remap = false },
	{ "<leader>y", group = "Clipboard", nowait = false, remap = false },
}
