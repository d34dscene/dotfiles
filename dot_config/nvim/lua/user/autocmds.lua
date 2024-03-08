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

command("FormatSave", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
	end
	require("conform").format { lsp_fallback = true, range = range }
	vim.cmd "w"
end, { range = true })

-- Function to automatically add missing imports
local function addMissingImports()
	local params = vim.lsp.util.make_range_params()
	params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

	-- Request code actions for the current buffer
	vim.lsp.buf_request(0, "textDocument/codeAction", params, function(_, _, actions)
		if not actions then
			return
		end

		for _, action in ipairs(actions) do
			if action.edit then
				-- Apply edits to add missing imports
				vim.lsp.util.apply_workspace_edit(action.edit)
			end
		end
	end)
end

-- Keymap to trigger the function
vim.api.nvim_set_keymap("n", "<leader>ia", ":lua addMissingImports()<CR>", { noremap = true, silent = true })

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
