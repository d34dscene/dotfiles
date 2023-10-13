local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

conform.setup {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { { "prettierd", "prettier" }, "eslint_d" },
		go = { "goimports", "gofmt", "golines" },
		cpp = { "clang_format" },
		c = { "clang-format" },
		terraform = { "terraform_fmt" },
		json = { "prettier" },
		toml = { "taplo" },
		yaml = { "yamlfix" },
		sh = { "shfmt" },
		zsh = { "shfmt" },
		bash = { "shfmt" },
		sql = { "sql_formatter" },
		markdown = { "mdformat" },
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
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