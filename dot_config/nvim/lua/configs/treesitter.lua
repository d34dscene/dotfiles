local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
	vim.notify("Failed to load treesitter", vim.log.levels.ERROR)
	return nil
end

treesitter.setup {
	ensure_installed = {
		"bash",
		"c",
		"go",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 1000 * 1024 -- 1 MB
			local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			scope_incremental = "<S-CR>",
			node_decremental = "<BS>",
		},
	},
	indent = { enable = true },
	autotag = { enable = true },
}
