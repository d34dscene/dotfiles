local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

bufferline.setup {
	highlights = require("catppuccin.groups.integrations.bufferline").get(),
	options = {
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", padding = 1 },
			{ filetype = "neo-tree", text = "File Explorer", padding = 1 },
			{ filetype = "CHADTree", text = "File Explorer", padding = 1 },
			{ filetype = "Outline", text = "File Explorer", padding = 1 },
		},
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, _, _)
			local icon = level:match "error" and " " or " "
			return " " .. icon .. count
		end,
		icon = "▎",
		buffer_close_icon = "󰛉",
		modified_icon = "",
		close_icon = "󰛉",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 18,
		max_prefix_length = 13,
		tab_size = 18,
		separator_style = "thin",
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
	},
}
