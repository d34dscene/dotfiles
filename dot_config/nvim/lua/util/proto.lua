local M = {}

function M.proto_renumber()
	local cursor_line = vim.fn.line "."

	-- Find the enclosing block by searching backwards and forwards from cursor
	local block_start = vim.fn.search("^\\s*\\(message\\|enum\\)\\s\\+\\w\\+\\s*{", "bnW")
	if block_start == 0 then
		vim.notify("No protobuf message or enum found around cursor", vim.log.levels.WARN)
		return
	end

	-- Get the line content to determine if it's a message or enum
	local block_start_line = vim.api.nvim_buf_get_lines(0, block_start - 1, block_start, false)[1]
	local is_enum = block_start_line:match "^%s*enum%s+"
	local block_type = is_enum and "enum" or "message"

	-- Find the matching closing brace for this specific block
	local block_end = M.find_matching_brace(block_start)
	if block_end == 0 then
		vim.notify("Could not find matching closing brace", vim.log.levels.ERROR)
		return
	end

	-- Verify cursor is within this block
	if cursor_line < block_start or cursor_line > block_end then
		vim.notify("Cursor is not within the found " .. block_type, vim.log.levels.WARN)
		return
	end

	-- Get lines within the block (excluding the opening and closing braces)
	local lines = vim.api.nvim_buf_get_lines(0, block_start, block_end - 1, false)

	-- Set starting counter based on type
	local counter = is_enum and 0 or 1

	-- Process each line
	for i, line in ipairs(lines) do
		local new_line
		if is_enum then
			-- For enums: match patterns like "FIELD_NAME = 1;" or "FIELD_NAME = 1 [deprecated = true];"
			new_line = line:gsub("(%w+)%s*=%s*%d+(%s*[;%[])", function(field_name, punct)
				local result = field_name .. " = " .. counter .. punct
				counter = counter + 1
				return result
			end)
		else
			-- For messages: match any line with "= number" pattern (much simpler and more robust)
			new_line = line:gsub("=%s*%d+(%s*[;%[])", function(punct)
				local space = (punct:match "^%s*%[" and " " or "")
				local result = "= " .. counter .. space .. punct
				counter = counter + 1
				return result
			end)
		end
		lines[i] = new_line
	end

	-- Update the buffer
	vim.api.nvim_buf_set_lines(0, block_start, block_end - 1, false, lines)

	local renumbered_count = counter - (is_enum and 0 or 1)
	vim.notify(string.format("Renumbered %d fields in %s", renumbered_count, block_type), vim.log.levels.INFO)
end

-- Helper function to find matching closing brace
function M.find_matching_brace(start_line)
	local brace_count = 0
	local line_count = vim.api.nvim_buf_line_count(0)

	for line_num = start_line, line_count do
		local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
		for char in line:gmatch "." do
			if char == "{" then
				brace_count = brace_count + 1
			elseif char == "}" then
				brace_count = brace_count - 1
				if brace_count == 0 then
					return line_num
				end
			end
		end
	end

	return 0 -- No matching brace found
end

return M
