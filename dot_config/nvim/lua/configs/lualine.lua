local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local function getLSP()
	local icon = "󰅴 "
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return icon
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return icon .. client.name
		end
	end
	return icon
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
		lualine_b = { "filename", { "branch", icon = "" }, "diagnostics" },
		lualine_c = { "fileformat", "diff" },
		lualine_x = {},
		lualine_y = { "filetype", "encoding", "filesize" }, --, { codeium, icon = "󱙺" } },
		lualine_z = { { getLSP, separator = { right = "", left_padding = 2 } } },
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
