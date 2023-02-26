local status_ok, null = pcall(require, "null-ls")
if not status_ok then
	return
end

local fmt = null.builtins.formatting
local ca = null.builtins.code_actions
local sources = {
	-- Code Action sources ----------------------------------------------------
	ca.cspell,
	ca.eslint_d,
	ca.gomodifytags,
	-- Formatter sources ------------------------------------------------------
	fmt.black,
	fmt.eslint_d,
	fmt.clang_format,
	fmt.gofmt,
	fmt.goimports,
	fmt.terraform_fmt,
	fmt.isort,
	fmt.packer,
	fmt.shfmt.with {
		extra_filetypes = { "zsh", "bash" },
	},
	fmt.stylua.with {
		extra_args = { "--quote-style", "ForceDouble", "--call-parentheses", "None" },
	},
	fmt.prettier.with {
		extra_args = function(params)
			return params.options and params.options.tabSize and {
				"--tab-width",
				params.options.tabSize,
			}
		end,
	},
}

local sync_formatting = function(bufnr)
	vim.lsp.buf.format {
		bufnr = bufnr,
		filter = function(client)
			return client.name == "null-ls"
		end,
	}
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null.setup {
	debug = false,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method "textDocument/formatting" then
			vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					sync_formatting(bufnr)
				end,
			})
		end
	end,
}
