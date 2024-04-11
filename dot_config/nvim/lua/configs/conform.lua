local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

local slow_format_filetypes = {}
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
		sql = { "sql_formatter" },
		markdown = { "mdformat" },
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
	format_on_save = function(bufnr)
		if slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end
		local function on_format(err)
			if err and err:match "timeout$" then
				slow_format_filetypes[vim.bo[bufnr].filetype] = true
			end
		end

		return { timeout_ms = 200, lsp_fallback = true }, on_format
	end,

	format_after_save = function(bufnr)
		if not slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end
		return { lsp_fallback = true }
	end,
}

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
	args = util.extend_args(yamlfmt.args, { "-formatter", "indent=2,retain_line_breaks=true" }),
})
