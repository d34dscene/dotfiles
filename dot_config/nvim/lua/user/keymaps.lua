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

-- Autocomplete when searching
--map("c", "<tab>", "<C-r><C-w>")

-- Standard Operations
map("n", "<leader>z", "<cmd>lua ReloadConfig()<CR>", { desc = "Reload config" })
map("n", "ss", "<cmd>w<cr>", { desc = "Save" })
map("n", "qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "zz", "<cmd>q!<cr>", { desc = "Force quit" })

-- Search and replace
map("n", "<leader>rr", ":%s///g<Left><Left>", { desc = "Replace all in current buffer" })
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace current word" })

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
map("n", "<A-.>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer tab" })
map("n", "<A-,>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer tab" })
map("n", "m.", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer tab right" })
map("n", "m,", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer tab left" })
map("n", "mm", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer tab" })

-- Buffer delete/wipeout & quit
map("n", "qw", "<cmd>w<cr><cmd>bp<cr>:bd #<cr>", { desc = "Save and close buffer" })
map("n", "qe", "<cmd>wa<cr><cmd>%bd|e#|bd#<cr>", { desc = "Save and close buffer" })
map("n", "qx", "<cmd>bd<cr>", { desc = "Quit" })

-- Neotree
map("n", "<leader>e", "<cmd>NeoTreeRevealToggle<cr>", { desc = "Open Neotree" })

-- Neogen
map("n", "<leader>n", ":lua require('neogen').generate()<cr>", { desc = "Neogen generate" })

-- Trouble
map("n", "<leader>x", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })

-- Aerial
map("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "Toggle Aerial" })

-- Markdown Preview
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

-- Lazy
map("n", "<leader>p", "<cmd>Lazy sync<cr>", { desc = "Update plugins" })

-- LSP Installer
map("n", "<leader>lm", "<cmd>Mason<cr>U", { desc = "Mason Update" })

-- Todo
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- -- Refactor
map("n", "rr", function()
	return ":IncRename " .. vim.fn.expand "<cword>"
end, { expr = true, desc = "Refactor" })

-- Codium
map("i", "cc", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true })
map("i", "<Right>", function()
	return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true })
map("i", "<Left>", function()
	return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true })
map("i", "xx", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true })

-- Text case
map("n", "tu", function()
	require("textcase").current_word "to_upper_case"
end, { desc = "Upper case" })
map("n", "tl", function()
	require("textcase").current_word "to_lower_case"
end, { desc = "Lower case" })
map("n", "ts", function()
	require("textcase").current_word "to_snake_case"
end, { desc = "Snake case" })
map("n", "tp", function()
	require("textcase").current_word "to_pascal_case"
end, { desc = "Pascal case" })
map("n", "tc", function()
	require("textcase").current_word "to_camel_case"
end, { desc = "Camel case" })
map("n", "tC", function()
	require("textcase").current_word "to_constant_case"
end, { desc = "Constant case" })

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
map("n", "gj", function()
	require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })
map("n", "gk", function()
	require("gitsigns").prev_hunk()
end, { desc = "Previous git hunk" })
map("n", "gr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset git hunk" })
map("n", "gs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage git hunk" })
map("n", "gu", function()
	require("gitsigns").undo_stage_hunk()
end, { desc = "Unstage git hunk" })
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

-- Ufo fix for german layout
map("n", "ym", "zR", { desc = "Open all folds" })
map("n", "yr", "zM", { desc = "Close all folds" })
map("n", "ya", "za", { desc = "Toggle fold under cursor" })

-- Move text up and down
map("n", "<A-Up>", ":move .-2<CR>==", { desc = "Move line up" })
map("n", "<A-Down>", ":move .+1<CR>==", { desc = "Move line down" })
map("v", "<A-Up>", ":move-2<cr>gv=gv", { desc = "Move block up" })
map("v", "<A-Down>", ":move'>+<cr>gv=gv", { desc = "Move block down" })

-- Jump between windows + close terminal
map("n", "<Tab>", "<C-w>w", { desc = "Jump to next window" })
map("n", "<S-Tab>", "<C-w>W", { desc = "Jump to previous window" })
map("t", "<Tab>", "<cmd>ToggleTerm<cr><C-w>w", { desc = "Jump to next window" })
map("t", "<S-Tab>", "<cmd>ToggleTerm<cr><C-w>W", { desc = "Jump to previous window" })

-- Extras
map("i", "<C-d>", "<Del>", opts) -- forward delete
map("i", "<C-H>", "<C-w>", opts) -- delete word
map("i", "<C-x>", "<Esc>ddi", opts) -- delete line
map("n", "<C-o>", "o<Esc>k", opts) -- newline
map("n", "<C-d>", "yyp", opts) -- duplicate line
map("n", "-", "<cmd>%&<cr>", opts) -- repeat substitution

-- Visual --
map("v", "p", "\"_dP", opts)
