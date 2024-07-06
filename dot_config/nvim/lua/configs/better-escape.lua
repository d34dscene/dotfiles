local status_ok, be = pcall(require, "better_escape")
if not status_ok then
	return
end

be.setup {
	timeout = vim.o.timeoutlen,
	mappings = {
		i = {
			q = {
				q = "<Esc>",
			},
		},
		c = {
			q = {
				q = "<Esc>",
			},
		},
		t = {
			q = {
				q = "<Esc>",
			},
		},
		v = {
			q = {
				q = "<Esc>",
			},
		},
		s = {
			q = {
				q = "<Esc>",
			},
		},
	},
}
