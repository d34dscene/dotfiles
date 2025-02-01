local function safe_require(module)
	local status_ok, result = pcall(require, module)
	if not status_ok then
		vim.notify("Failed to load " .. module, vim.log.levels.ERROR)
		return nil
	end
	return result
end

local lspconfig = safe_require "lspconfig"
local mason_lspconfig = safe_require "mason-lspconfig"
local tsbuiltin = safe_require "telescope.builtin"
if not (lspconfig and mason_lspconfig and tsbuiltin) then
	return
end

mason_lspconfig.setup {
	ensure_installed = {
		"ansiblels",
		"buf_ls",
		"clangd",
		"dockerls",
		"eslint",
		"golangci_lint_ls",
		"gopls",
		"helm_ls",
		"jsonls",
		"lua_ls",
		"marksman",
		"pyright",
		"solc",
		"sqlls",
		"svelte",
		"tailwindcss",
		"yamlls",
	},
}

local diagnostic_signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "󰌵" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(diagnostic_signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

-- Enhanced diagnostics config
vim.diagnostic.config {
	virtual_text = {
		spacing = 4,
		prefix = "",
		severity_sort = true,
		source = "if_many",
		format = function(diagnostic)
			return string.format("%s [%s]", diagnostic.message, diagnostic.source)
		end,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
}

local on_attach = function(_, bufnr)
	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.noremap = true
		opts.silent = true
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		style = "minimal",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		style = "minimal",
	})

	-- Mappings.
	map("n", "gt", tsbuiltin.lsp_definitions, { desc = "Goto Definition" })
	map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
	map("n", "gr", tsbuiltin.lsp_references, { desc = "Goto References" })
	map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
	map("n", "M", vim.lsp.buf.hover, { desc = "Hover Documentation" })
	map("n", "gh", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })
	map("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { desc = "List workspace folders" })
	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
	map("n", "<leader>f", function()
		vim.lsp.buf.format { async = true }
	end, { desc = "Format buffer" })

	-- Lesser used LSP functionality
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
	map("n", "gd", vim.lsp.buf.definition, { desc = "Type Definition" })
	map("n", "gy", vim.lsp.buf.type_definition, { desc = "Type Definition" })
end

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				experimentalPostfixCompletions = true,
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
				gofumpt = true, -- Stricter formatting
				usePlaceholders = true,
			},
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
	clangd = {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	},
	bufls = {
		filetypes = { "proto" },
	},
}

mason_lspconfig.setup_handlers {
	function(server_name)
		local opts = {
			on_attach = on_attach,
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		}

		-- Merge server-specific settings
		if servers[server_name] then
			opts = vim.tbl_deep_extend("force", opts, servers[server_name])
		end

		lspconfig[server_name].setup(opts)
	end,
}
