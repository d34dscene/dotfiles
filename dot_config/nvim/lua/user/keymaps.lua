local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Remap space as leader key
map("", "<Space>", "<Nop>")

-- Standard Operations
map("n", "ss", "<cmd>w<cr>", { desc = "Save" })
map("n", "qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "zz", "<cmd>q!<cr>", { desc = "Force quit" })

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
map("n", "<leader>v", "<C-w>v", { desc = "Create vertical split" })
map("n", "<A-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<A-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<A-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<A-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-k>", "<cmd>resize -2<cr>", { desc = "Resize split up" })
map("n", "<C-j>", "<cmd>resize +2<cr>", { desc = "Resize split down" })
map("n", "<C-h>", "<cmd>vertical resize -2<cr>", { desc = "Resize split left" })
map("n", "<C-l>", "<cmd>vertical resize +2<cr>", { desc = "Resize split right" })

-- Navigate buffers
map("n", "<A-Right>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer tab" })
map("n", "<A-Left>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer tab" })
map("n", "<A-.>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer tab right" })
map("n", "<A-,>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer tab left" })
map("n", "mp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer tab" })

-- Buffer delete/wipeout & quit
map("n", "qw", "<cmd>w<cr><cmd>bp<cr>:bd #<cr>", { desc = "Save and close buffer" })
map("n", "qe", "<cmd>wa<cr><cmd>%bd|e#|bd#<cr>", { desc = "Save and close all buffer" })
map("n", "qx", "<cmd>bd<cr>", { desc = "Quit" })

-- Neotree
map("n", "<leader>e", "<cmd>NeoTreeRevealToggle<cr>", { desc = "Open Neotree" })

-- false
map("n", "<leader>n", ":lua require('neogen').generate()<cr>", { desc = "Neogen generate" })

-- Trouble
map("n", "<leader>x", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })

-- Markdown Preview
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

-- Lazy
map("n", "<leader>ll", "<cmd>Lazy sync<cr>", { desc = "Update plugins" })

-- LSP Installer
map("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" })

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
map("i", "<A-]>", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true })
map("i", "<PageUp>", function()
	return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true })
map("i", "<PageDown>", function()
	return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true })
map("i", "<A-[>", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true })

-- Comment
map("n", "x", function()
	require("Comment.api").toggle.linewise.current(nil, {})
end, { desc = "Comment line" })
map(
	"v",
	"x",
	"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
	{ desc = "Comment block" }
)

-- GitSigns
map("n", "gn", function()
	require("gitsigns").toggle_numhl()
end, { desc = "Toggle number highlight" })
map("n", "gl", function()
	require("gitsigns").toggle_linehl()
end, { desc = "Toggle line highlight" })
map("n", "gd", function()
	require("gitsigns").toggle_deleted()
end, { desc = "Toggle deleted lines" })

-- Telescope
map("n", "<leader>fw", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
map("n", "<leader>gt", function()
	require("telescope.builtin").git_status()
end, { desc = "Git status" })
map("n", "<leader>gb", function()
	require("telescope.builtin").git_branches()
end, { desc = "Git branchs" })
map("n", "<leader>gc", function()
	require("telescope.builtin").git_commits()
end, { desc = "Git commits" })
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Search files" })
map("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Search buffers" })
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
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search Todos" })

-- Leap
map({ "n", "x", "v" }, "f", "<Plug>(leap-forward-to)", { desc = "Leap forward" })
map({ "n", "x", "v" }, "t", "<Plug>(leap-forward-till)", { desc = "Leap forward till" })
map({ "n", "x", "v" }, "F", "<Plug>(leap-backward-to)", { desc = "Leap backward" })
map({ "n", "x", "v" }, "T", "<Plug>(leap-backward-till)", { desc = "Leap backward till" })
map({ "n", "x", "v" }, "sf", "<Plug>(leap-from-window)", { desc = "Leap window" })

-- Ufo
map("n", "m.", "zR", { desc = "Open all folds" })
map("n", "m,", "zM", { desc = "Close all folds" })
map("n", "mm", "za", { desc = "Toggle fold under cursor" })

-- Move text up and down
map("n", "<A-Up>", ":move .-2<CR>==", { desc = "Move line up" })
map("n", "<A-Down>", ":move .+1<CR>==", { desc = "Move line down" })
map("v", "<A-Up>", ":move-2<cr>gv=gv", { desc = "Move block up" })
map("v", "<A-Down>", ":move'>+<cr>gv=gv", { desc = "Move block down" })

-- Jump between windows + close terminal
map("n", "<Tab>", "<C-w>w", { desc = "Jump to next window" })
map("n", "<S-Tab>", "<C-w>W", { desc = "Jump to previous window" })

-- Extras
map("i", "<A-BS>", "<C-w>", opts) -- delete word
map("i", "<C-x>", "<Esc>ddi", opts) -- delete line
map("n", "<C-d>", "yyp", opts) -- duplicate line
map("n", "++", "o<Esc>k", opts) -- newline
map("n", "-", "<cmd>%&<cr>", opts) -- repeat substitution
map("n", "<C-x>", "^y$jA<Space><Esc>pkdd", opts) -- paste at end of line

-- Autocomplete when searching
-- map("c", "<tab>", "<C-r><C-w>") -- replaced by wilder

-- Visual --
map("v", "p", "\"_dP", opts)
