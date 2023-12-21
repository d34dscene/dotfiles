local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
	end
	require("conform").format { async = true, lsp_fallback = true, range = range }
end, { range = true })

cmd("BufWritePre", {
	desc = "Format on save",
	group = augroup("format_on_save", { clear = true }),
	pattern = "*",
	callback = function(args)
		require("conform").format { bufnr = args.buf, lsp_fallback = true }
	end,
})

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

cmd("BufWritePre", {
	desc = "Run gofmt and goimports on save",
	group = augroup("gofmt", { clear = true }),
	pattern = "*.go",
	callback = function()
		require("go.format").goimport()
		require("go.format").gofmt()
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

cmd("CursorHold", {
	desc = "Show line diagnostics in hover window",
	group = augroup("show_line_diagnostics", { clear = true }),
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
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
