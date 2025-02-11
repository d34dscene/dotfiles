local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

conform.setup {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		go = { "goimports", "gofumpt", "golines" },
		cpp = { "clang_format" },
		c = { "clang_format" },
		terraform = { "terraform_fmt" },
		json = { "prettier", "fixjson" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },
		svelte = { "prettier" },
		vue = { "prettier" },
		astro = { "prettier" },
		markdown = { "prettier" },
		yaml = { "yamlfmt" },
		sh = { "shfmt", "shellcheck" },
		zsh = { "shfmt", "shellcheck" },
		bash = { "shfmt", "shellcheck" },
		proto = { "buf" },
		rust = { "rustfmt" },
		sql = { "sql_formatter" },
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
}

-- Custom commands
local command = vim.api.nvim_create_user_command

command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
	end
	conform.format { async = true, lsp_fallback = true, range = range }
end, { range = true })

command("FormatSave", function()
	conform.format { lsp_fallback = true }
	vim.cmd "w"
end, { desc = "Format and save" })

command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- Add custom args to formatter
local util = require "conform.util"
local stylua = require "conform.formatters.stylua"
conform.formatters.stylua = vim.tbl_deep_extend("force", stylua, {
	args = util.extend_args(stylua.args, { "--quote-style", "ForceDouble", "--call-parentheses", "None" }),
})

local black = require "conform.formatters.black"
conform.formatters.black = vim.tbl_deep_extend("force", black, {
	args = util.extend_args(black.args, { "--line-length", "79" }),
})

local yamlfmt = require "conform.formatters.yamlfmt"
conform.formatters.yamlfmt = vim.tbl_deep_extend("force", yamlfmt, {
	args = util.extend_args(
		yamlfmt.args,
		{ "-formatter", "indent=2,retain_line_breaks=true,scan_folded_as_literal=true" }
	),
})
