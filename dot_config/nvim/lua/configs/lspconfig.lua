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
		"solc",
		"sqlls",
		"tailwindcss",
		"tsserver",
		"volar",
		"yamlls",
	},
	automatic_installation = true,
}

local on_attach = function(client, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, {
			buffer = bufnr,
			desc = desc,
		})
	end

	-- Disable diagnostic for helm charts
	-- if vim.bo[bufnr].filetype == "helm" then
	-- 	vim.diagnostic.disable(bufnr)
	-- 	vim.defer_fn(function()
	-- 		vim.diagnostic.reset(nil, bufnr)
	-- 	end, 1000)
	-- end

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	--map("<leader>rn", vim.lsp.buf.rename, "Refactor") -- Replaced by inc-rename
	map("<leader>lc", vim.lsp.buf.code_action, "Code Action")

	map("gt", tsbuiltin.lsp_definitions, "Goto Definition")
	map("gi", vim.lsp.buf.implementation, "Goto Implementation")
	map("gr", tsbuiltin.lsp_references, "Goto References")
	map("<leader>ld", tsbuiltin.lsp_document_symbols, "Document Symbols")
	map("<leader>lp", tsbuiltin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

	-- See `:help K` for why this keymap
	map("M", vim.lsp.buf.hover, "Hover Documentation")
	map("gh", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	map("gD", vim.lsp.buf.declaration, "Goto Declaration")
	map("<leader>lt", vim.lsp.buf.type_definition, "Type Definition")
	map("<leader>la", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
	map("<leader>lg", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
	map("<leader>li", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "Workspace List Folders")

	map("<leader>f", function()
		vim.lsp.buf.format { async = true }
	end, "Format file")

	-- Get nvim-navic working with multiple tabs
	if client.server_capabilities["documentSymbolProvider"] then
		require("nvim-navic").attach(client, bufnr)
	end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities = {
	offsetEncoding = "utf-16",
	textDocument = {
		completion = {
			completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			},
		},
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
	},
}

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
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
				yaml = {
					completion = true,
					schemaStore = {
						enable = true,
					},
				},
				gopls = {
					hints = {
						constantValues = true,
						parameterNames = true,
					},
				},
			},
		}
	end,
}
