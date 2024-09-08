local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

conform.setup {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettier", "eslint_d" },
		typescript = { "prettier", "eslint_d" },
		go = { "goimports", "gofumpt", "golines" },
		cpp = { "clang_format" },
		c = { "clang_format" },
		terraform = { "terraform_fmt" },
		json = { "prettier", "fixjson" },
		yaml = { "yamlfmt" },
		sh = { "shfmt", "shellcheck" },
		zsh = { "shfmt", "shellcheck" },
		bash = { "shfmt", "shellcheck" },
		proto = { "buf" },
		sql = { "sql_formatter" },
		markdown = { "mdformat" },
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
}

-- Custom commands
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
	end
	conform.format { async = true, lsp_fallback = true, range = range }
end, { range = true })

vim.api.nvim_create_user_command("FormatSave", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
	end
	conform.format { lsp_fallback = true, range = range }
	vim.cmd "w"
end, { range = true })

-- Add custom args to formatter
local util = require "conform.util"
local stylua = require "conform.formatters.stylua"
conform.formatters.stylua = vim.tbl_deep_extend("force", stylua, {
	args = util.extend_args(stylua.args, { "--quote-style", "ForceDouble", "--call-parentheses", "None" }),
})

local prettier = require "conform.formatters.prettier"
conform.formatters.prettier = vim.tbl_deep_extend("force", prettier, {
	args = util.extend_args(prettier.args, { "--tab", "--indent", "4" }),
})

local yamlfmt = require "conform.formatters.yamlfmt"
conform.formatters.yamlfmt = vim.tbl_deep_extend("force", yamlfmt, {
	args = util.extend_args(
		yamlfmt.args,
		{ "-formatter", "indent=2,retain_line_breaks=true,scan_folded_as_literal=true" }
	),
})
