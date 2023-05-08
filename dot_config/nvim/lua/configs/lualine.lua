local status_ok, ll = pcall(require, "lualine")
if not status_ok then
	return
end

local function getLspName()
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return ""
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= "null-ls" then
			return " " .. client.name
		end
	end
	return " "
end

local lsp = {
	function()
		return getLspName()
	end,
	separator = { right = "" },
	left_padding = 2,
}

ll.setup {
	options = {
		theme = "catppuccin",
		component_separators = "|",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		},
		lualine_b = { "filename", "branch", "diagnostics" },
		lualine_c = { "fileformat", "diff" },
		lualine_x = {},
		lualine_y = { "filetype", "encoding", "filesize" },
		lualine_z = { lsp },
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = { "neo-tree", "toggleterm" },
}
