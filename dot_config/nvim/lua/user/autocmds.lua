local cmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup

cmd({ "FocusGained", "TermClose", "TermLeave" }, {
	desc = "Reload the file when it changed",
	group = augroup("checktime", { clear = true }),
	command = "checktime",
})

cmd("TextYankPost", {
	desc = "Highlight on yanked text",
	group = augroup("highlightyank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

cmd("VimResized", {
	desc = "Resize splits if window got resized",
	group = augroup("resize_splits", { clear = true }),
	callback = function()
		vim.cmd "tabdo wincmd ="
	end,
})

cmd("FileType", {
	desc = "Wrap and spell check text in text files",
	group = augroup("wrap_text", { clear = true }),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

cmd("FileType", {
	desc = "Unlist quickfist buffers",
	group = augroup("unlist_quickfist", { clear = true }),
	pattern = "qf",
	callback = function()
		vim.opt_local.buflisted = false
	end,
})

cmd("FileType", {
	desc = "Disable continuation of comments",
	group = augroup("disable_continuation", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove { "c", "r", "o" }
	end,
})

cmd({ "BufRead", "BufNewFile" }, {
	desc = "Detect .zshrc and similar files as zsh filetype",
	group = augroup("zsh_filetype", { clear = true }),
	pattern = { ".zsh*" },
	callback = function()
		vim.bo.filetype = "zsh"
	end,
})

cmd("BufWritePre", {
	desc = "Format Go code",
	group = augroup("go_format", { clear = true }),
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
})

cmd("User", {
	desc = "Show git conflict markers",
	group = augroup("show_git_conflict_markers", { clear = true }),
	pattern = "GitConflictDetected",
	callback = function()
		vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
	end,
})

cmd({ "BufWinEnter", "TextChanged", "TextChangedI" }, {
	desc = "Start linting",
	group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
	callback = function()
		require("lint").try_lint()
	end,
})

-- Extra filetypes
cmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.gohtml,*.gotmpl,*.html",
	callback = function()
		if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_set_option_value("filetype", "gotmpl", { buf = buf })
			vim.api.nvim_set_option_value("filetype", "html", { buf = buf })
		end
	end,
})

cmd({ "BufNewFile", "BufRead" }, {
	pattern = ".envrc,.envrc.enc,.envrc.dec",
	callback = function()
		vim.bo.filetype = "sh"
	end,
})

command("ProtoRenumber", function()
	require("util.proto").proto_renumber()
end, {})

local large_file_size = 1000000 -- 1MB
cmd("BufReadPre", {
	desc = "Disable certain features for large files",
	group = augroup("large_file_optimization", { clear = true }),
	callback = function()
		local file_size = vim.fn.getfsize(vim.fn.expand "%")
		if file_size > large_file_size then
			vim.opt_local.syntax = "off"
			vim.opt_local.swapfile = false
			vim.opt_local.bufhidden = "unload"
			vim.opt_local.undofile = false
			vim.opt_local.foldenable = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
			vim.opt_local.relativenumber = false
			vim.opt_local.number = false
		end
	end,
})
