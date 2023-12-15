local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local status_ok_ts, tsbuiltin = pcall(require, "telescope.builtin")
if not status_ok and not status_ok_ts then
	return
end

mason_lspconfig.setup {
	ensure_installed = {
		"clangd",
		"dockerls",
		"gopls",
		"html",
		"helm_ls",
		"jdtls",
		"jsonls",
		"lua_ls",
		"marksman",
		"pyright",
		"sqlls",
		"tailwindcss",
		"tsserver",
		"yamlls",
	},
	automatic_installation = true,
}

local on_attach = function(_, bufnr)
	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Disable diagnostic for helm charts
	if vim.bo[bufnr].filetype == "helm" then
		vim.diagnostic.disable(bufnr)
		vim.defer_fn(function()
			vim.diagnostic.reset(nil, bufnr)
		end, 1000)
	end

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	--map("<leader>rn", vim.lsp.buf.rename, "Refactor") -- Replaced by inc-rename
	map("n", "<leader>lc", vim.lsp.buf.code_action, "Code Action")

	map("n", "gt", tsbuiltin.lsp_definitions, "Goto Definition")
	map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
	map("n", "gr", tsbuiltin.lsp_references, "Goto References")
	map("n", "[d", vim.diagnostic.goto_prev, "Goto previous diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "Goto next diagnostic")
	map("n", "<leader>ld", tsbuiltin.lsp_document_symbols, "Document Symbols")
	map("n", "<leader>lp", tsbuiltin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

	-- See `:help K` for why this keymap
	map("n", "M", vim.lsp.buf.hover, "Hover Documentation")
	map("n", "gh", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
	map("n", "<leader>lt", vim.lsp.buf.type_definition, "Type Definition")
	map("n", "<leader>la", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
	map("n", "<leader>lg", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
	map("n", "<leader>li", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "Workspace List Folders")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
mason_lspconfig.setup_handlers {
	function(server_name)
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
	end,
}
