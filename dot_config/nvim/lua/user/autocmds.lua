local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local url_matcher =
	"\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

local function delete_url_match()
	for _, match in ipairs(vim.fn.getmatches()) do
		if match.group == "HighlightURL" then
			vim.fn.matchdelete(match.id)
		end
	end
end

local function set_url_match()
	delete_url_match()
	if vim.g.highlighturl_enabled then
		vim.fn.matchadd("HighlightURL", url_matcher, 15)
	end
end

local function leave_snippet()
	if
		((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
		and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
		and not require("luasnip").session.jump_active
	then
		require("luasnip").unlink_current()
	end
end

-- stop snippets when you leave to normal mode
cmd("ModeChanged", {
	pattern = "*",
	callback = function()
		leave_snippet()
	end,
})

cmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
	desc = "URL Highlighting",
	group = augroup("highlighturl", { clear = true }),
	pattern = "*",
	callback = function()
		set_url_match()
	end,
})

cmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = augroup("highlightyank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

cmd({
	"WinResized",
	"BufWinEnter",
	"CursorHold",
	"InsertLeave",
	"BufWritePost",
	"TextChanged",
	"TextChangedI",
}, {
	group = vim.api.nvim_create_augroup("barbecue.updater", {}),
	callback = function()
		require("barbecue.ui").update()
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
