local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Modes
--   normal "n",
--   insert "i",
--   visual "v",
--   visual_block "x",
--   command "c",
--   term "t",

-- Remap space as leader key
map("", "<Space>", "<Nop>")

-- Standard Operations
map("i", "qq", "<esc>", { desc = "Escape" })
map("t", "qq", "<C-\\><C-n>", { desc = "Escape" })
map("n", "qw", "<cmd>wa | qa<cr>", { desc = "Save and quit" })

-- Search and replace
map("n", "rt", ":%s///g<Left><Left>", { desc = "Replace all in current buffer" })
map("n", "rw", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", { desc = "Replace current word" })

-- Splits
map("n", "vv", "<C-w>v", { desc = "Vertical split" })

-- Smart buffer close/quit
map("n", "qq", function()
	local buftype = vim.bo.buftype
	local modified = vim.bo.modified
	local buf_count = #vim.fn.getbufinfo { buflisted = 1 }

	-- For special buffers (like CodeCompanion, help, etc)
	if buftype ~= "" then
		vim.cmd "q"
		return
	end

	-- Save if modified
	if modified then
		vim.cmd "w"
	end

	-- Get all normal windows showing listed buffers
	local real_windows = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
		local listed = vim.api.nvim_get_option_value("buflisted", { buf = buf })
		if bt == "" and listed then
			table.insert(real_windows, win)
		end
	end

	-- If we're in a real split (more than one real window), close this one
	if #real_windows > 1 then
		vim.cmd "close"
		return
	end

	-- If it's the last buffer, quit
	if buf_count <= 1 then
		vim.cmd "q"
	else
		vim.cmd "bp|bd #"
	end
end, { desc = "Smart quit: save & close buffer or quit" })

-- Lazy
map("n", "<leader>ll", ":Lazy sync<cr>", { desc = "Update plugins" })

-- Jump between windows
map("n", "<Tab>", "<C-w>w", { desc = "Jump to next window" })
map("n", "<S-Tab>", "<C-w>W", { desc = "Jump to previous window" })

-- Extras
map("n", "<C-d>", "yyp", opts) -- duplicate line
map("n", "--", "O<Esc>j", opts) -- newline below
map("n", "==", "o<Esc>k", opts) -- newline above
map("n", "]]", ":%&<cr>", opts) -- repeat substitution
map("n", "<C-a>", "gg<S-v>G", opts) -- select all
map("n", "<C-x>", "^y$jA<Space><Esc>pkdd", opts) -- paste at end of line

-- Stay in indent mode when indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Sort lines
map("v", "<leader>sl", ":sort<CR>", { desc = "Sort lines" })
map("v", "<leader>sr", ":sort!<cr>", { desc = "Sort lines reverse" })
map("v", "<leader>su", ":sort u<cr>", { desc = "Sort unique lines" })

-- Autocomplete when searching
--map("c", "<tab>", "<C-r><C-w>")

-- Visual --
map("v", "p", "\"_dP", opts)
map("v", "q", "<Esc>", opts)
