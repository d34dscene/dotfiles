local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok then
	vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
	return nil
end

-- ============================================================================
-- Mason LSP Config
-- ============================================================================

mason_lspconfig.setup {
	ensure_installed = {
		"bashls",
		"buf_ls",
		"clangd",
		"dockerls",
		"gopls",
		"golangci_lint_ls",
		"helm_ls",
		"oxlint",
		"lua_ls",
		"marksman",
		"ruff",
		"svelte",
		"tailwindcss",
		"yamlls",
		"vtsls",
	},
	automatic_installation = true,
}

-- ============================================================================
-- LSP Capabilities Setup (blink.cmp integration)
-- ============================================================================

local function get_capabilities()
	-- Check if blink.cmp is available
	local has_blink, blink = pcall(require, "blink.cmp")

	if has_blink and blink.get_lsp_capabilities then
		-- Merge default capabilities with blink.cmp capabilities
		return vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), blink.get_lsp_capabilities(), {
			-- Additional capabilities can be added here
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		})
	else
		-- Fallback to default capabilities if blink.cmp is not available
		return vim.lsp.protocol.make_client_capabilities()
	end
end

-- ============================================================================
-- LSP Keymaps (set on attach)
-- ============================================================================

local function setup_keymaps(bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc, silent = true })
	end

	-- Navigation
	local pickerOk, picker = pcall(require, "snacks.picker")
	if pickerOk then
		map("n", "gd", function()
			picker.lsp_definitions()
		end, "Goto Definition")
		map("n", "gD", function()
			picker.lsp_declarations()
		end, "Goto Declaration")
		map("n", "gr", function()
			picker.lsp_references()
		end, "Goto References")
		map("n", "gi", function()
			picker.lsp_implementations()
		end, "Goto Implementation")
		map("n", "gt", function()
			picker.lsp_type_definitions()
		end, "Goto Type Definition")
	else
		map("n", "gd", vim.lsp.buf.definition, "Goto definition")
		map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
		map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
		map("n", "gr", vim.lsp.buf.references, "Goto references")
		map("n", "gt", vim.lsp.buf.type_definition, "Goto type definition")
	end

	-- Information
	map("n", "K", vim.lsp.buf.hover, "Hover documentation")
	map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
	map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

	-- Code actions
	map({ "n", "v" }, "<leader>cx", vim.lsp.buf.code_action, "Code action (cursor)")
	map("n", "<leader>ca", function()
		vim.lsp.buf.code_action {
			context = { only = { "source" }, diagnostics = vim.diagnostic.get(0) },
		}
	end, "Code action (buffer)")
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	map("n", "<leader>cf", function()
		vim.lsp.buf.format { async = true }
	end, "Format buffer")

	-- Diagnostics
	map("n", "<leader>yd", "<cmd>CopyDiagnostics<cr>", "Copy diagnostic")
	map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
	map("n", "<leader>cd", vim.diagnostic.open_float, "Show diagnostic")
	map("n", "<leader>cl", vim.diagnostic.setloclist, "Diagnostics to loclist")

	-- Workspace
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "List workspace folders")
end

-- ============================================================================
-- LSP Attach Handler
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not client then
			return
		end

		-- Setup keymaps for this buffer
		setup_keymaps(bufnr)

		-- Enable completion triggered by <c-x><c-o>
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Disable inlay hints
		if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
		end

		-- Document highlight on cursor hold
		if client.server_capabilities.documentHighlightProvider then
			local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				group = highlight_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = bufnr,
				group = highlight_group,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

-- ============================================================================
-- Diagnostic Configuration
-- ============================================================================

vim.diagnostic.config {
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
}

-- ============================================================================
-- LSP Server Setup
-- ============================================================================

local overrides = {
	eslint = {
		settings = {
			workingDirectories = { mode = "auto" },
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = {
					globals = { "vim", "require" },
					disable = { "different-requires" },
				},
			},
		},
	},
	oxlint = {
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"svelte",
			"vue",
			"astro",
		},
	},
	ruff = {
		settings = {
			logLevel = "info",
		},
	},
	pyright = {
		disableOrganizeImports = true,
	},
	python = {
		analysis = {
			ignore = { "*" },
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	yamlls = {
		completion = true,
		schemaStore = { enable = false, url = "" },
		schemas = require("schemastore").yaml.schemas(),
	},
	svelte = {
		capabilities = {
			workspace = {
				didChangeWatchedFiles = vim.fn.has "nvim-0.10" == 0 and { dynamicRegistration = true },
			},
		},
	},
}

vim.lsp.config("*", {
	capabilities = get_capabilities(),
	root_markers = { ".git" },
})

for server, opts in pairs(overrides) do
	vim.lsp.config(
		server,
		vim.tbl_deep_extend("force", {
			capabilities = get_capabilities(),
		}, opts)
	)
end

-- ============================================================================
-- Utility Commands
-- ============================================================================

-- LspStatus: Show brief LSP status
vim.api.nvim_create_user_command("LspStatus", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients { bufnr = bufnr }

	if #clients == 0 then
		print "󰅚 No LSP clients attached"
		return
	end

	print("󰒋 LSP Status for buffer " .. bufnr .. ":")
	print "─────────────────────────────────"

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
		print("  Root: " .. (client.config.root_dir or "N/A"))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		local caps = client.server_capabilities
		local features = {}
		if caps.completionProvider then
			table.insert(features, "completion")
		end
		if caps.hoverProvider then
			table.insert(features, "hover")
		end
		if caps.definitionProvider then
			table.insert(features, "definition")
		end
		if caps.referencesProvider then
			table.insert(features, "references")
		end
		if caps.renameProvider then
			table.insert(features, "rename")
		end
		if caps.codeActionProvider then
			table.insert(features, "code_action")
		end
		if caps.documentFormattingProvider then
			table.insert(features, "formatting")
		end

		print("  Features: " .. table.concat(features, ", "))
		print ""
	end
end, { desc = "Show brief LSP status" })

-- LspCapabilities: Show all capabilities for attached LSP clients
vim.api.nvim_create_user_command("LspCapabilities", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients { bufnr = bufnr }

	if #clients == 0 then
		print "No LSP clients attached"
		return
	end

	for _, client in ipairs(clients) do
		print("Capabilities for " .. client.name .. ":")
		local caps = client.server_capabilities

		local capability_list = {
			{ "Completion", caps.completionProvider },
			{ "Hover", caps.hoverProvider },
			{ "Signature Help", caps.signatureHelpProvider },
			{ "Go to Definition", caps.definitionProvider },
			{ "Go to Declaration", caps.declarationProvider },
			{ "Go to Implementation", caps.implementationProvider },
			{ "Go to Type Definition", caps.typeDefinitionProvider },
			{ "Find References", caps.referencesProvider },
			{ "Document Highlight", caps.documentHighlightProvider },
			{ "Document Symbol", caps.documentSymbolProvider },
			{ "Workspace Symbol", caps.workspaceSymbolProvider },
			{ "Code Action", caps.codeActionProvider },
			{ "Code Lens", caps.codeLensProvider },
			{ "Document Formatting", caps.documentFormattingProvider },
			{ "Document Range Formatting", caps.documentRangeFormattingProvider },
			{ "Rename", caps.renameProvider },
			{ "Folding Range", caps.foldingRangeProvider },
			{ "Selection Range", caps.selectionRangeProvider },
			{ "Inlay Hint", caps.inlayHintProvider },
		}

		for _, cap in ipairs(capability_list) do
			local status = cap[2] and "✓" or "✗"
			print(string.format("  %s %s", status, cap[1]))
		end
		print ""
	end
end, { desc = "Show all LSP capabilities" })

-- LspDiagnostics: Show diagnostic counts
vim.api.nvim_create_user_command("LspDiagnostics", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

	for _, diagnostic in ipairs(diagnostics) do
		local severity = vim.diagnostic.severity[diagnostic.severity]
		counts[severity] = counts[severity] + 1
	end

	print "󰒡 Diagnostics for current buffer:"
	print("  Errors: " .. counts.ERROR)
	print("  Warnings: " .. counts.WARN)
	print("  Info: " .. counts.INFO)
	print("  Hints: " .. counts.HINT)
	print("  Total: " .. #diagnostics)
end, { desc = "Show diagnostic counts for current buffer" })

-- LspInfo: Comprehensive LSP information
vim.api.nvim_create_user_command("LspInfo", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients { bufnr = bufnr }

	print "═══════════════════════════════════"
	print "           LSP INFORMATION          "
	print "═══════════════════════════════════"
	print ""

	print("󰈙 Language client log: " .. vim.lsp.get_log_path())
	print("󰈔 Detected filetype: " .. vim.bo.filetype)
	print("󰈮 Buffer: " .. bufnr)
	print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
	print ""

	if #clients == 0 then
		print("󰅚 No LSP clients attached to buffer " .. bufnr)
		print ""
		print "Possible reasons:"
		print("  • No language server installed for " .. vim.bo.filetype)
		print "  • Language server not configured"
		print "  • Not in a project root directory"
		print "  • File type not recognized"
		return
	end

	print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
	print "─────────────────────────────────"

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s", i, client.name))
		print("  ID: " .. client.id)
		print("  Root dir: " .. (client.config.root_dir or "Not set"))
		print("  Command: " .. table.concat(client.config.cmd or {}, " "))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		if client.is_stopped() then
			print "  Status: 󰅚 Stopped"
		else
			print "  Status: 󰄬 Running"
		end

		if client.workspace_folders and #client.workspace_folders > 0 then
			print "  Workspace folders:"
			for _, folder in ipairs(client.workspace_folders) do
				print("    • " .. folder.name)
			end
		end

		local attached_buffers = {}
		for buf, _ in pairs(client.attached_buffers or {}) do
			table.insert(attached_buffers, buf)
		end
		print("  Attached buffers: " .. #attached_buffers)

		local caps = client.server_capabilities
		local key_features = {}
		if caps.completionProvider then
			table.insert(key_features, "completion")
		end
		if caps.hoverProvider then
			table.insert(key_features, "hover")
		end
		if caps.definitionProvider then
			table.insert(key_features, "definition")
		end
		if caps.documentFormattingProvider then
			table.insert(key_features, "formatting")
		end
		if caps.codeActionProvider then
			table.insert(key_features, "code_action")
		end

		if #key_features > 0 then
			print("  Key features: " .. table.concat(key_features, ", "))
		end

		print ""
	end

	local diagnostics = vim.diagnostic.get(bufnr)
	if #diagnostics > 0 then
		print "󰒡 Diagnostics Summary:"
		local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

		for _, diagnostic in ipairs(diagnostics) do
			local severity = vim.diagnostic.severity[diagnostic.severity]
			counts[severity] = counts[severity] + 1
		end

		print("  󰅚 Errors: " .. counts.ERROR)
		print("  󰀪 Warnings: " .. counts.WARN)
		print("  󰋽 Info: " .. counts.INFO)
		print("  󰌶 Hints: " .. counts.HINT)
		print("  Total: " .. #diagnostics)
	else
		print "󰄬 No diagnostics"
	end

	print ""
	print "Use :LspLog to view detailed logs"
	print "Use :LspCapabilities for full capability list"
end, { desc = "Show comprehensive LSP information" })

vim.api.nvim_create_user_command("CopyDiagnostics", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local col = vim.api.nvim_win_get_cursor(0)[2]

	-- Get diagnostics at cursor position
	local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

	if #diagnostics == 0 then
		vim.notify("No diagnostics at cursor", vim.log.levels.INFO)
		return
	end

	-- Filter diagnostics that actually overlap with cursor position
	local cursor_diagnostics = {}
	for _, d in ipairs(diagnostics) do
		if col >= d.col and col <= d.end_col then
			table.insert(cursor_diagnostics, d)
		end
	end

	-- If no exact match, use all diagnostics on the line
	if #cursor_diagnostics == 0 then
		cursor_diagnostics = diagnostics
	end

	local function copy_diagnostic(diagnostic)
		if not diagnostic then
			vim.notify("No diagnostic provided", vim.log.levels.WARN)
			return
		end
		local severity = vim.diagnostic.severity[diagnostic.severity]
		local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
		local message = source .. diagnostic.message
		vim.fn.setreg("+", message)
		vim.notify("Copied " .. severity .. " diagnostic to clipboard", vim.log.levels.INFO)
	end

	if #cursor_diagnostics == 1 then
		copy_diagnostic(cursor_diagnostics[1])
	else
		-- Format diagnostics for selection
		local items = {}
		for _, d in ipairs(cursor_diagnostics) do
			local severity = vim.diagnostic.severity[d.severity]
			local source = d.source and ("[" .. d.source .. "] ") or ""
			table.insert(items, {
				text = string.format("[%s] %s%s", severity, source, d.message),
				diagnostic = d,
			})
		end

		vim.ui.select(items, {
			prompt = "Select diagnostic to copy:",
			format_item = function(item)
				return item.text
			end,
		}, function(choice)
			if choice then
				copy_diagnostic(choice.diagnostic)
			end
		end)
	end
end, { desc = "Copy diagnostic at cursor to clipboard" })
