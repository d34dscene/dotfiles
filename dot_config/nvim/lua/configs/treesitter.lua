local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup {
	auto_install = true,
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = function(lang, buf) -- Disable on large files
			local max_filesize = 1000 * 1024 -- 1 MB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true },
	autotag = { enable = true },
}
