local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok then
	vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
	return nil
end

mason_lspconfig.setup {
	ensure_installed = {
		"ansiblels",
		"bashls",
		"biome",
		"buf_ls",
		"clangd",
		"dockerls",
		"eslint",
		"gopls",
		"golangci_lint_ls",
		"helm_ls",
		"jdtls",
		"jsonls",
		"kotlin_lsp",
		"lua_ls",
		"marksman",
		"ruff",
		"solc",
		"svelte",
		"tailwindcss",
		"yamlls",
	},
}

-- Enhanced diagnostics settings
vim.diagnostic.config {
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	virtual_text = true,
	virtual_lines = { current_line = true },
	update_in_insert = false,
	underline = true,
	severity_sort = true,
}
local function copy_diagnostics()
	local buf = vim.api.nvim_get_current_buf()
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local diagnostics = vim.diagnostic.get(buf, {
		lnum = lnum - 1, -- need 0-based index
		-- this will select only `ERROR` or `WARN`,
		severity = { min = vim.diagnostic.severity.WARN },
	})

	if vim.tbl_isempty(diagnostics) then
		vim.notify(string.format("Line %d has no diagnostics.", lnum))
		return
	end

	table.sort(diagnostics, function(a, b)
		return a.severity < b.severity
	end)

	-- Extract unique severities
	local severities = {}
	for _, d in ipairs(diagnostics) do
		severities[d.severity] = true
	end

	local result = nil

	if #diagnostics == 1 or vim.tbl_count(severities) == 1 then
		-- Yank directly if only one diagnostic or one type of severity
		result = vim.trim(diagnostics[1].message)
	else
		-- Let user select if multiple severities present
		vim.ui.select(diagnostics, {
			prompt = "Select diagnostic:",
			format_item = function(diag)
				local severity = diag.severity == vim.diagnostic.severity.ERROR and "ERROR" or "WARNING"
				return string.format("%s: [%s] %s (%s)", severity, diag.code, vim.trim(diag.message), diag.source)
			end,
		}, function(choice)
			if choice then
				result = vim.trim(choice.message)
			end
		end)
	end

	-- Use a loop to wait for async select to complete if necessary
	vim.defer_fn(function()
		if result then
			vim.fn.setreg(vim.v.register, result)
			vim.fn.setreg("+", result)
			vim.notify(string.format("Yanked diagnostic to register `%s`: %s", vim.v.register, result))
		end
	end, 10)
end

local on_attach = function(_, bufnr)
	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.noremap = true
		opts.silent = true
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Mappings
	local pickerOk, picker = pcall(require, "snacks.picker")
	if pickerOk then
		map("n", "gd", function()
			picker.lsp_definitions()
		end, { desc = "Goto Definition" })
		map("n", "gD", function()
			picker.lsp_declarations()
		end, { desc = "Goto Declaration" })
		map("n", "gr", function()
			picker.lsp_references()
		end, { nowait = true, desc = "Goto References" })
		map("n", "gi", function()
			picker.lsp_implementations()
		end, { nowait = true, desc = "Goto Implementation" })
		map("n", "gy", function()
			picker.lsp_type_definitions()
		end, { desc = "Goto Type Definition" })
	end

	map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
	map("n", "gh", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })
	map("n", "<leader>cx", vim.lsp.buf.code_action, { desc = "Code Action (Cursor)" })
	map("n", "<leader>ca", function()
		vim.lsp.buf.code_action {
			context = { only = { "source" }, diagnostics = vim.diagnostic.get(0) },
		}
	end, { desc = "Code Action (Buffer)" })

	map("n", "<leader>yd", copy_diagnostics, { desc = "Yank Diagnostic" })
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { desc = "List workspace folders" })
	map("n", "<leader>f", function()
		vim.lsp.buf.format { async = true }
	end, { desc = "Format buffer" })
end

local servers = {
	buf_ls = {
		on_attach = function(client, _)
			client.server_capabilities.semanticTokensProvider = nil
		end,
	},
	basedpyright = {
		settings = {
			basedpyright = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					typeCheckingMode = "basic",
				},
			},
		},
	},
	clangd = {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	},
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
					globals = { "vim" },
					disable = { "different-requires" },
				},
				workspace = {
					library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	gopls = {
		filetypes = { "go", "gomod", "gowork" },
		settings = {
			gopls = {
				buildFlags = { "-tags=dev" },
				experimentalPostfixCompletions = true,
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
				gofumpt = true,
				usePlaceholders = true,
			},
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

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Merges general on_attach with a server-specific one
local function merge_on_attach(server_on_attach)
	return function(client, bufnr)
		on_attach(client, bufnr)
		if server_on_attach then
			server_on_attach(client, bufnr)
		end
	end
end

for server, opts in pairs(servers) do
	vim.lsp.config(server, {
		on_attach = merge_on_attach(opts.on_attach),
		flags = { debounce_text_changes = 150 },
		settings = opts.settings,
		filetypes = opts.filetypes,
		capabilities = capabilities,
	})
	vim.lsp.enable(server)
end
