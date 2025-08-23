local ok, lualine = pcall(require, "lualine")
if not ok then
	vim.notify("Failed to load lualine", vim.log.levels.ERROR)
	return nil
end

-- CodeCompanion status integration
local codecompanion = {}
codecompanion.processing = false
codecompanion.spinner_index = 1

local spinner_symbols = { ".  ", ".. ", "...", " ..", "  ." }
local spinner_symbols_len = #spinner_symbols

-- Create autocmds to update processing state based on CodeCompanion events
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
vim.api.nvim_create_autocmd("User", {
	pattern = "CodeCompanionRequest*",
	group = group,
	callback = function(request)
		if request.match == "CodeCompanionRequestStarted" then
			codecompanion.processing = true
		elseif request.match == "CodeCompanionRequestFinished" then
			codecompanion.processing = false
		end
	end,
})

-- Function to return the spinner symbol when processing
local function codecompanion_status()
	if codecompanion.processing then
		codecompanion.spinner_index = (codecompanion.spinner_index % spinner_symbols_len) + 1
		return spinner_symbols[codecompanion.spinner_index]
	else
		return ""
	end
end

-- LSP name abbreviations map
local lsp_shortnames = {
	["golangci_lint_ls"] = "gc-lint",
	["tailwindcss"] = "tailwind",
}

local function getLSP()
	local buf_ft = vim.bo.filetype
	local active_clients = {}

	for _, client in ipairs(vim.lsp.get_clients()) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			local short_name = lsp_shortnames[client.name] or client.name:sub(1, 6)
			table.insert(active_clients, short_name)
		end
	end

	return table.concat(active_clients, "|")
end

local function getLineCount()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "" then
		local starts = vim.fn.line "v"
		local ends = vim.fn.line "."
		local count = starts <= ends and ends - starts + 1 or starts - ends + 1
		local wc = vim.fn.wordcount()
		return string.format("󰦨 %d lines (%d words)", count, wc["visual_words"])
	end
	return ""
end

local function getFileSize()
	local file = vim.fn.expand "%:p"
	if file == nil or file == "" then
		return ""
	end
	local size = vim.fn.getfsize(file)
	if size < 1024 then
		return string.format("%dB", size)
	elseif size < 1024 * 1024 then
		return string.format("%.1fKB", size / 1024)
	else
		return string.format("%.1fMB", size / (1024 * 1024))
	end
end

lualine.setup {
	options = {
		theme = "catppuccin",
		component_separators = "|",
		section_separators = { left = "", right = "" },
		globalstatus = true,
		refresh = {
			statusline = 300,
			tabline = 300,
			winbar = 300,
		},
	},

	sections = {
		lualine_a = {
			{ "mode", separator = { left = "" } },
		},
		lualine_b = {
			"filename",
			{ "branch", icon = "" },
			"diagnostics",
		},
		lualine_c = { "fileformat", "diff" },
		lualine_x = {},
		lualine_y = {
			"filetype",
			"encoding",
			getLineCount,
			{ getFileSize, icon = "󰋊" },
			{ codecompanion_status, icon = "󰚩 " },
		},
		lualine_z = {
			{
				getLSP,
				icon = "󰅬",
				separator = { right = "", left_padding = 2 },
			},
		},
	},
	tabline = {
		-- lualine_a = {
		-- 	{
		-- 		"buffers",
		-- 		use_mode_colors = true,
		-- 		hide_filename_extension = true,
		-- 		mode = 0,
		-- 		symbols = {
		-- 			modified = " ●",
		-- 			alternate_file = "",
		-- 			directory = "",
		-- 		},
		-- 	},
		-- },
		-- lualine_b = {},
		-- lualine_c = {},
		-- lualine_x = {},
		-- lualine_y = {},
		-- lualine_z = { "tabs" },
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	extensions = { "lazy", "mason", "neo-tree" },
}
