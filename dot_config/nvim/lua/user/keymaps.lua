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
map("n", "ss", ":FormatSave<cr>", { desc = "Save" })
map("n", "qq", ":q<cr>", { desc = "Quit" })

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

-- Buffer delete/wipeout & quit
map("n", "qw", ":w|bp|bd #<cr>", { desc = "Save and close buffer" })
map("n", "qe", ":wa|BufferLineCloseOthers<cr>", { desc = "Save and close all buffer" })

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
map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", { desc = "Code companion actions" })
map({ "n", "v" }, "<leader>cx", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Code companion chat toggle" })
map("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add visually selected chat" })
map("n", "<leader>cd", function()
	require("codecompanion").prompt "debug_buffer"
end, { desc = "Debug buffer" })
map("n", "<leader>cs", function()
	require("codecompanion").prompt "document_buffer"
end, { desc = "Document buffer" })

-- Comment
map("n", "x", function()
	require("Comment.api").toggle.linewise.current(nil, {})
end, { desc = "Comment line" })
map("v", "x", "<esc>:lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", { desc = "Comment block" })

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

-- Telescope
map("n", "<leader>fw", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
map("n", "<leader>fs", function()
	require("telescope.builtin").git_status()
end, { desc = "Git status" })
map("n", "<leader>fb", function()
	require("telescope.builtin").git_branches()
end, { desc = "Git branches" })
map("n", "<leader>fg", function()
	require("telescope.builtin").git_bcommits()
end, { desc = "Git commits" })
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Search files" })
map("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Search help" })
map("n", "<leader>fk", function()
	require("telescope.builtin").marks()
end, { desc = "Search marks" })
map("n", "<leader>fo", function()
	require("telescope.builtin").oldfiles()
end, { desc = "Search history" })
map("n", "<leader>fm", function()
	require("telescope.builtin").man_pages()
end, { desc = "Search man" })
map("n", "<leader>fy", function()
	require("telescope.builtin").keymaps()
end, { desc = "Search keymaps" })
map("n", "<leader>fc", function()
	require("telescope.builtin").commands()
end, { desc = "Search commands" })
map("n", "<leader>fr", function()
	require("telescope.builtin").lsp_references()
end, { desc = "Search references" })
map("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Search diagnostics" })
map("n", "<leader>ft", ":TodoTelescope<cr>", { desc = "Search Todos" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
map("n", "<leader>xf", "<cmd>Trouble diagnostics toggle filter.buf=4<cr>", { desc = "Buffer Diagnostics" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

-- Markdown Preview
map("n", "<leader>m", ":MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

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

-- Paste from clipboard
-- map({ "n", "v" }, "<leader>p", "\"+p", { desc = "Paste below" })
-- map({ "n", "v" }, "<leader>P", "\"+P", { desc = "Paste above" })
map("n", "<leader>pp", "V\"+p", { desc = "Overwrite line" })

-- Sort lines
map("x", "<leader>sl", ":sort<CR>", { desc = "Sort lines" })
map("x", "<leader>sr", ":sort!<cr>", { desc = "Sort lines reverse" })
map("x", "<leader>su", ":sort u<cr>", { desc = "Sort unique lines" })

-- Autocomplete when searching
--map("c", "<tab>", "<C-r><C-w>")

-- Visual --
map("v", "p", "\"_dP", opts)
map("v", "q", "<Esc>", opts)
