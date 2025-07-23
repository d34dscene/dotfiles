local M = {}

function M.proto_renumber()
	local start_line = vim.fn.search("{", "bnW")
	local end_line = vim.fn.search("}", "nW")
	if start_line == 0 or end_line == 0 then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line - 1, false)
	local counter = 1
	for i, line in ipairs(lines) do
		local new = line:gsub("= %d+%s*([;%[])", function(punct)
			local space = (punct == "[" and " " or "")
			local out = "= " .. counter .. space .. punct
			counter = counter + 1
			return out
		end)
		lines[i] = new
	end
	vim.api.nvim_buf_set_lines(0, start_line, end_line - 1, false, lines)
end

return M
