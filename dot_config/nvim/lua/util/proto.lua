local M = {}

function M.proto_renumber()
	-- Save the exact cursor position to restore later
	local win = vim.api.nvim_get_current_win()
	local cursor_pos = vim.api.nvim_win_get_cursor(win)

	-- Find the start of the message/enum block
	local start_line = vim.fn.search("^\\s*\\(message\\|enum\\)\\s\\+\\w\\+", "cbW")
	if start_line == 0 then
		vim.notify("No protobuf message or enum found around cursor", vim.log.levels.WARN)
		return
	end

	-- Determine type to set the starting counter
	local line_str = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
	local is_enum = line_str:match "^%s*enum%s+"
	local counter = is_enum and 0 or 1
	local block_type = is_enum and "enum" or "message"

	-- Use Neovim's built-in searchpair to reliably find the matching closing brace (handles nesting)
	vim.fn.cursor(start_line, 1)
	vim.fn.search("{", "cW")
	local end_line = vim.fn.searchpair("{", "", "}", "W")

	-- Ensure we found an end and that the original cursor was inside this block
	if end_line == 0 or cursor_pos[1] < start_line or cursor_pos[1] > end_line then
		vim.api.nvim_win_set_cursor(win, cursor_pos) -- Restore cursor
		vim.notify("Cursor is not within a valid " .. block_type, vim.log.levels.WARN)
		return
	end

	-- Fetch lines inside the block
	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line - 1, false)
	local renumbered_count = 0

	for i, line in ipairs(lines) do
		-- Skip comments and file/message level options
		if not line:match "^%s*//" and not line:match "^%s*option%s+" then
			-- Match the identifier before the '=', the number, and the trailing ';' or '['
			-- The '1' at the end of gsub ensures we only replace the FIRST match per line.
			local new_line, replaced = line:gsub("([^%s=]+)%s*=%s*%d+(%s*[;%[])", function(name, punct)
				local result = name .. " = " .. counter .. punct
				counter = counter + 1
				return result
			end, 1)

			if replaced > 0 then
				lines[i] = new_line
				renumbered_count = renumbered_count + 1
			end
		end
	end

	-- Apply changes and restore cursor
	vim.api.nvim_buf_set_lines(0, start_line, end_line - 1, false, lines)
	vim.api.nvim_win_set_cursor(win, cursor_pos)

	vim.notify(string.format("Renumbered %d fields in %s", renumbered_count, block_type), vim.log.levels.INFO)
end

return M
