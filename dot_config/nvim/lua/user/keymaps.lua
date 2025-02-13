local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Modes
--   normal_"n",
--   insert_"i",
--   visual_"v",
--   visual_block_"x",
--   term_"t",
--   command_"c",

-- Remap space as leader key
map("", "<Space>", "<Nop>")

-- Standard Operations
map("i", "qq", "<esc>", { desc = "Escape" })
map("t", "qq", "<C-\\><C-n>", { desc = "Escape" })
map("n", "ss", "<cmd>FormatSave<cr>", { desc = "Save" })
map("n", "qw", "<cmd>wa | qa<cr>", { desc = "Save and quit" })

-- Search and replace
map("n", "rt", ":%s///g<Left><Left>", { desc = "Replace all in current buffer" })
map("n", "rw", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", { desc = "Replace current word" })

-- Refactor
map("n", "rr", function()
	return ":IncRename "
end, { expr = true, desc = "Refactor new name" })
map("n", "re", function()
	return ":IncRename " .. vim.fn.expand "<cword>"
end, { expr = true, desc = "Refactor expand" })

-- Splits
map("n", "vv", "<C-w>v", { desc = "Vertical split" })
map("n", "<A-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<A-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<A-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<A-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-k>", ":resize 2<cr>", { desc = "Resize split up" })
map("n", "<C-j>", ":resize +6<cr>", { desc = "Resize split down" })
map("n", "<C-h>", ":vertical resize 2<cr>", { desc = "Resize split left" })
map("n", "<C-l>", ":vertical resize +6<cr>", { desc = "Resize split right" })

-- Navigate buffers
map("n", "<A-k>", ":BufferLineCycleNext<cr>", { desc = "Next buffer tab" })
map("n", "<A-j>", ":BufferLineCyclePrev<cr>", { desc = "Previous buffer tab" })
map("n", "<A-K>", ":BufferLineMoveNext<cr>", { desc = "Move buffer tab right" })
map("n", "<A-J>", ":BufferLineMovePrev<cr>", { desc = "Move buffer tab left" })
map("n", "mp", ":BufferLinePick<cr>", { desc = "Pick buffer tab" })

-- Smart buffer close/quit
map("n", "qq", function()
	local buftype = vim.bo.buftype
	local modified = vim.bo.modified

	-- For special buffers (like CodeCompanion, help, etc)
	if buftype ~= "" then
		vim.cmd "q"
		return
	end

	-- For normal buffers: save if modified
	if modified and buftype == "" then
		vim.cmd "w"
	end

	-- If it's the last buffer, quit
	if #vim.fn.getbufinfo { buflisted = 1 } <= 1 then
		vim.cmd "q"
	else
		vim.cmd "bp|bd #"
	end
end, { desc = "Smart quit: save & close buffer or quit" })

-- Spider
map({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
map({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

-- Neotree
map("n", "<leader>e", function()
	require("neo-tree.command").execute {
		toggle = true,
		source = "filesystem",
		position = "left",
	}
end, { desc = "Open Neotree" })

-- Lazy
map("n", "<leader>ll", ":Lazy sync<cr>", { desc = "Update plugins" })

-- LSP
map("n", "<leader>lm", ":Mason<cr>", { desc = "Mason UI" })
map("n", "<leader>lr", ":LspRestart<cr>", { desc = "Restart LSP" })

-- Formatter
map("n", "<leader>lf", ":ConformInfo<cr>", { desc = "Conform Info" })
map("n", "<leader>li", ":LspInfo<cr>", { desc = "LSP Info" })

-- Code actions preview
map({ "v", "n" }, "cc", function()
	require("actions-preview").code_actions { context = { only = { "source" } } }
end, { desc = "Code actions Buffer" })
map({ "v", "n" }, "ca", function()
	require("actions-preview").code_actions()
end, { desc = "Code actions preview" })

-- Treesj
map("n", "tt", function()
	require("treesj").toggle()
end, { desc = "Toggle node under cursor" })

-- Todo
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- Codium
map("i", "<A-f>", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true })
map("i", "<PageUp>", function()
	return vim.fn["codeium#CycleCompletions"](5)
end, { expr = true })
map("i", "<PageDown>", function()
	return vim.fn["codeium#CycleCompletions"](3)
end, { expr = true })
map("i", "<A-[>", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true })

-- CodeCompanion
map({ "n", "v", "i" }, "<A-\\>", function()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	local is_codecompanion = vim.bo[buf].filetype == "codecompanion"

	if is_codecompanion then
		vim.cmd "CodeCompanionChat Toggle"
		vim.cmd "stopinsert"
	else
		vim.cmd "CodeCompanionChat Toggle"
		vim.cmd "startinsert"
	end
end, { desc = "Code companion chat toggle" })
map({ "n", "v" }, "<A-->", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Code companion chat toggle" })
map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", { desc = "Code companion actions" })
map("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add visually selected chat" })
map("n", "<leader>cd", function()
	require("codecompanion").prompt "debug_buffer"
end, { desc = "Debug buffer" })
map("n", "<leader>cs", function()
	require("codecompanion").prompt "document_buffer"
end, { desc = "Document buffer" })

-- Comment
map("n", "x", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Comment line" })
map("v", "x", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Comment block" })

-- Go
map("n", "<leader>gf", ":GoFillStruct<cr>", { desc = "Go fill struct" })
map("n", "<leader>ga", ":GoAddTag<cr>", { desc = "Go add tags" })
map("n", "<leader>gr", ":GoRmTag<cr>", { desc = "Go remove tags" })
map("n", "<leader>gm", ":GoModTidy<cr>", { desc = "Go mod tidy" })
map("n", "<leader>gl", ":GoLint<cr>", { desc = "Go lint" })
map("n", "<leader>gt", ":GoAddAllTest -bench<cr>", { desc = "Go add tests" })
map("n", "<leader>gv", ":GoCoverage<cr>", { desc = "Go coverage" })

-- Git Conflict
map("n", "<leader>gc", ":GitConflictListQf<cr>", { desc = "Git conflict" })

-- Markdown Preview
map("n", "<leader>m", ":MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

-- Snacks
---- Terminal
map({ "n", "t", "i" }, "\\", function()
	local ft = vim.bo.filetype
	local count = vim.v.count
	if ft == "snacks_terminal" and count == 0 then
		vim.cmd "close"
	else
		Snacks.terminal.toggle(nil, { count = count })
	end
	-- Reset count
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
end, { desc = "Toggle terminal" })

---- Git
map("n", "<leader>gb", function()
	Snacks.gitbrowse.open()
end, { desc = "Git browse" })

---- Picker
map("n", "<leader>ff", function()
	Snacks.picker.smart()
end, { desc = "Find Files" })
map("n", "<leader>fu", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fw", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fs", function()
	Snacks.picker.git_status()
end, { desc = "Git Status" })
map("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Git Files" })
map("n", "<leader>fb", function()
	Snacks.picker.git_branches()
end, { desc = "Git Branches" })
map("n", "<leader>fi", function()
	Snacks.picker.git_diff()
end, { desc = "Git Diff" })
map("n", "<leader>fo", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>fd", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>ft", function()
	Snacks.picker.todo_comments()
end, { desc = "Todo Comments" })

---- Buffer
map("n", "qe", function()
	vim.cmd "wa"
	Snacks.bufdelete.other()
end, { desc = "Close other buffers" })

-- Flash
map({ "n", "x", "o" }, "f", function()
	require("flash").jump {
		search = {
			mode = function(str)
				return "\\<" .. str
			end,
		},
	}
end, { desc = "Flash" })

-- Move text up and down
map("n", "<A-Up>", ":move .-2<CR>==", { desc = "Move line up" })
map("n", "<A-Down>", ":move .+1<CR>==", { desc = "Move line down" })
map("v", "<A-Up>", ":move-2<CR>gv=gv", { desc = "Move block up" })
map("v", "<A-Down>", ":move'>+<CR>gv=gv", { desc = "Move block down" })

-- Jump between windows + close terminal
map("n", "<Tab>", "<C-w>w", { desc = "Jump to next window" })
map("n", "<S-Tab>", "<C-w>W", { desc = "Jump to previous window" })

-- Extras
map("i", "<A-BS>", "<C-w>", opts) -- delete word
map("i", "<C-x>", "<Esc>ddi", opts) -- delete line
map("i", "<C-c>", "<Esc>yyi", opts) -- copy line
map("i", "<C-.>", "<Esc>pi", opts) -- paste line
map("n", "<C-d>", "yyp", opts) -- duplicate line
map("n", "--", "O<Esc>j", opts) -- newline below
map("n", "==", "o<Esc>k", opts) -- newline above
map("n", "]]", ":%&<cr>", opts) -- repeat substitution
map("n", "<C-a>", "gg<S-v>G", opts) -- select all
map("n", "<C-x>", "^y$jA<Space><Esc>pkdd", opts) -- paste at end of line

-- Copy to clipboard
map({ "n", "v" }, "y", "\"+y", { desc = "Copy to clipboard" })
map({ "n", "v" }, "Y", "\"+yg_", { desc = "Copy to clipboard" })

-- Stay in indent mode when indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Paste from clipboard
map("n", "<leader>pp", "V\"+p", { desc = "Overwrite line" })

-- Sort lines
map("v", "<leader>sl", ":sort<CR>", { desc = "Sort lines" })
map("v", "<leader>sr", ":sort!<cr>", { desc = "Sort lines reverse" })
map("v", "<leader>su", ":sort u<cr>", { desc = "Sort unique lines" })

-- Autocomplete when searching
--map("c", "<tab>", "<C-r><C-w>")

-- Visual --
map("v", "p", "\"_dP", opts)
map("v", "q", "<Esc>", opts)
