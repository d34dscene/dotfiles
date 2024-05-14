local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local status_ok_t, tool = pcall(require, "mason-tool-installer")
local status_ok_ts, tsbuiltin = pcall(require, "telescope.builtin")
if not status_ok and not status_ok_t and not status_ok_ts then
	return
end

tool.setup {
	ensure_installed = {
		"black",
		"buf",
		"clangd",
		"eslint_d",
		"gofumpt",
		"golines",
		"gomodifytags",
		"gopls",
		"gotests",
		"isort",
		"jdtls",
		"marksman",
		"prettier",
		"shellcheck",
		"shfmt",
		"sql-formatter",
		"sqlls",
		"staticcheck",
		"stylua",
		"helm-ls",
		"html-lsp",
		"emmet-language-server",
		"buf-language-server",
		"dockerfile-language-server",
		"golangci-lint-langserver",
		"lua-language-server",
		"svelte-language-server",
		"tailwindcss-language-server",
		"typescript-language-server",
		"python-lsp-server",
		"vim-language-server",
		"yaml-language-server",
	},

	auto_update = true,
	run_on_start = true,
}

local on_attach = function(_, bufnr)
	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.noremap = true
		opts.silent = true
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
		vim.diagnostic.disable()
	end

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	map("n", "gt", tsbuiltin.lsp_definitions, { desc = "Goto Definition" })
	map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
	map("n", "gr", tsbuiltin.lsp_references, { desc = "Goto References" })
	map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
	map("n", "M", vim.lsp.buf.hover, { desc = "Hover Documentation" })
	map("n", "gh", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })
	map("n", "<leader>ls", function()
		require("lsp_signature").toggle_float_win()
	end, { desc = "Toggle Signature" })

	-- Lesser used LSP functionality
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
	map("n", "gd", vim.lsp.buf.definition, { desc = "Type Definition" })
	map("n", "gy", vim.lsp.buf.type_definition, { desc = "Type Definition" })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
mason_lspconfig.setup_handlers {
	function(server_name)
		if server_name == "clangd" then
			require("lspconfig").clangd.setup {
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			}
		else
			require("lspconfig")[server_name].setup {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
					yaml = {
						completion = true,
						schemaStore = {
							enable = true,
						},
						schemas = {
							["https://goreleaser.com/static/schema.json"] = ".goreleaser.{yml,yaml}",
						},
					},
					gopls = {
						experimentalPostfixCompletions = true,
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			}
		end
	end,
}
