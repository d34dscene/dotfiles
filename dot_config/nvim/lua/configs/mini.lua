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
local comment = safe_require "mini.comment"
local diff = safe_require "mini.diff"
local hipatterns = safe_require "mini.hipatterns"
local icons = safe_require "mini.icons"
local jump = safe_require "mini.jump"
local move = safe_require "mini.move"
local pairs = safe_require "mini.pairs"
local splitjoin = safe_require "mini.splitjoin"
local surround = safe_require "mini.surround"

align.setup {}
bracketed.setup {}
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
hipatterns.setup {
	highlighters = {
		bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "DiagnosticError" },
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "DiagnosticError" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "DiagnosticWarn" },
		wip = { pattern = "%f[%w]()WIP()%f[%W]", group = "DiagnosticHint" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "DiagnosticInfo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "DiagnosticInfo" },
	},
}
icons.setup {}
jump.setup {}
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
pairs.setup {}
splitjoin.setup { mappings = { toggle = "tt" } }
surround.setup {}

-- Icons
icons.mock_nvim_web_devicons()
