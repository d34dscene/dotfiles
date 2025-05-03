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
local conform = safe_require "conform"
if not (lspconfig and mason_lspconfig and conform) then
	return
end

mason_lspconfig.setup {
	ensure_installed = {
		"ansiblels",
		"bashls",
		"buf_ls",
		"clangd",
		"dockerls",
		"eslint",
		"gopls",
		"helm_ls",
		"jsonls",
		"lua_ls",
		"marksman",
		"ruff",
		"solc",
		"sqlls",
		"svelte",
		"tailwindcss",
		"vtsls",
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

	-- Mappings
	map("n", "gd", function()
		Snacks.picker.lsp_definitions()
	end, { desc = "Goto Definition" })
	map("n", "gD", function()
		Snacks.picker.lsp_declarations()
	end, { desc = "Goto Declaration" })
	map("n", "gr", function()
		Snacks.picker.lsp_references()
	end, { nowait = true, desc = "Goto References" })
	map("n", "gi", function()
		Snacks.picker.lsp_implementations()
	end, { nowait = true, desc = "Goto Implementation" })
	map("n", "gy", function()
		Snacks.picker.lsp_type_definitions()
	end, { desc = "Goto Type Definition" })
	map("n", "M", vim.lsp.buf.hover, { desc = "Hover Documentation" })
	map("n", "gh", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })
	map("n", "<leader>cx", vim.lsp.buf.code_action, { desc = "Code Action (Cursor)" })
	map("n", "<leader>ca", function()
		vim.lsp.buf.code_action {
			context = { only = { "source" }, diagnostics = vim.diagnostic.get(0) },
		}
	end, { desc = "Code Action (Buffer)" })

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
	eslint = {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end,
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
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
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
	yaml = {
		completion = true,
		schemaStore = {
			enable = false,
			url = "",
		},
		schemas = require("schemastore").yaml.schemas(),
	},
	clangd = {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	},
	bufls = {
		filetypes = { "proto" },
	},
	typescript = {
		updateImportsOnFileMove = "always",
	},
	javascript = {
		updateImportsOnFileMove = "always",
	},
	svelte = {
		capabilities = {
			workspace = {
				didChangeWatchedFiles = vim.fn.has "nvim-0.10" == 0 and { dynamicRegistration = true },
			},
		},
	},
	vtsls = {
		settings = {
			complete_function_calls = true,
			vtsls = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
				experimental = {
					maxInlayHintLength = 30,
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
			},
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = {
					completeFunctionCalls = true,
				},
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
			},
		},
		keys = {
			{
				"<leader>co",
				function()
					vim.lsp.buf.code_action {
						apply = true,
						context = {
							only = { "source.organizeImports" },
							diagnostics = {},
						},
					}
				end,
				desc = "Organize Imports",
			},
			{
				"<leader>cM",
				function()
					vim.lsp.buf.code_action {
						apply = true,
						context = {
							only = { "source.addMissingImports.ts" },
							diagnostics = {},
						},
					}
				end,
				desc = "Add missing imports",
			},
			{
				"<leader>cu",
				function()
					vim.lsp.buf.code_action {
						apply = true,
						context = {
							only = { "source.removeUnused.ts" },
							diagnostics = {},
						},
					}
				end,
				desc = "Remove unused imports",
			},
			{
				"<leader>cD",
				function()
					vim.lsp.buf.code_action {
						apply = true,
						context = {
							only = { "source.fixAll.ts" },
							diagnostics = {},
						},
					}
				end,
				desc = "Fix all diagnostics",
			},
		},
		-- on_attach = function(client, bufnr)
		-- 	on_attach(client, bufnr)
		-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 		buffer = bufnr,
		-- 		callback = function()
		-- 			vim.lsp.buf.code_action {
		-- 				apply = true,
		-- 				context = {
		-- 					only = { "source.organizeImports" },
		-- 					diagnostics = {},
		-- 				},
		-- 			}
		-- 			vim.lsp.buf.code_action {
		-- 				apply = true,
		-- 				context = {
		-- 					only = { "source.addMissingImports.ts" },
		-- 					diagnostics = {},
		-- 				},
		-- 			}
		-- 			vim.lsp.buf.code_action {
		-- 				apply = true,
		-- 				context = {
		-- 					only = { "source.removeUnused.ts" },
		-- 					diagnostics = {},
		-- 				},
		-- 			}
		-- 		end,
		-- 	})
		-- end,
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
