local function safe_require(module_name)
	local ok, plugin = pcall(require, module_name)
	if not ok then
		vim.notify("Failed to load " .. module_name, vim.log.levels.ERROR)
		return setmetatable({}, {
			__index = function()
				return function() end
			end,
		})
	end
	return plugin
end

local align = safe_require "mini.align"
local bracketed = safe_require "mini.bracketed"
local bufremove = safe_require "mini.bufremove"
local comment = safe_require "mini.comment"
local diff = safe_require "mini.diff"
local icons = safe_require "mini.icons"
local jump2d = safe_require "mini.jump2d"
local move = safe_require "mini.move"
local surround = safe_require "mini.surround"

align.setup {}
bracketed.setup {}
bufremove.setup {}
comment.setup {
	options = {
		ignore_blank_line = true,
		pad_comment_parts = true,
	},
	mappings = {
		comment_line = "x",
		comment_visual = "x",
	},
}
diff.setup {}
icons.setup {}
jump2d.setup { mappings = { start_jumping = "f" } }
move.setup {
	mappings = {
		left = "<M-left>",
		right = "<M-right>",
		down = "<M-down>",
		up = "<M-up>",

		line_left = "<M-left>",
		line_right = "<M-right>",
		line_down = "<M-down>",
		line_up = "<M-up>",
	},
}
surround.setup {}

-- Icons
icons.mock_nvim_web_devicons()
