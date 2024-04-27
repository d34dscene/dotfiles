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
map("n", "ss", "<cmd>w<cr>", { desc = "Save" })
map("n", "qq", "<cmd>q<cr>", { desc = "Quit" })

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
map("n", "<A-k>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer tab" })
map("n", "<A-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer tab" })
map("n", "<A-K>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer tab right" })
map("n", "<A-J>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer tab left" })
map("n", "mp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer tab" })

-- Buffer delete/wipeout & quit
map("n", "qw", "<cmd>w|bp|bd #<cr>", { desc = "Save and close buffer" })
map("n", "qe", "<cmd>wa|BufferLineCloseOthers<cr>", { desc = "Save and close all buffer" })

-- Neotree
map("n", "<leader>e", function()
	require("neo-tree.command").execute {
		toggle = true,
		source = "filesystem",
		position = "left",
	}
end, { desc = "Open Neotree" })

-- Markdown Preview
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

-- Lazy
map("n", "<leader>ll", "<cmd>Lazy sync<cr>", { desc = "Update plugins" })

-- LSP
map("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason UI" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Formatter
map("n", "<leader>lf", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })

-- Code actions preview
map({ "v", "n" }, "<leader>cc", function()
	require("actions-preview").code_actions { context = { only = { "source" } } }
end, { desc = "Code actions Buffer" })
map({ "v", "n" }, "<leader>ca", function()
	require("actions-preview").code_actions()
end, { desc = "Code actions preview" })

-- Treesj
map("n", "tt", function()
	require("treesj").toggle()
end, { desc = "Toggle node under cursor" })

-- Tree climber
map({ "n", "v", "o" }, "H", function()
	require("tree-climber").goto_parent()
end, { desc = "Tree parent" })
map({ "n", "v", "o" }, "L", function()
	require("tree-climber").goto_child()
end, { desc = "Tree child" })
map({ "n", "v", "o" }, "J", function()
	require("tree-climber").goto_next()
end, { desc = "Tree next node" })
map({ "n", "v", "o" }, "K", function()
	require("tree-climber").goto_prev()
end, { desc = "Tree prev node" })
map({ "v", "o" }, "in", function()
	require("tree-climber").select_node()
end, { desc = "Tree select node" })
map("n", "<c-l>", function()
	require("tree-climber").swap_prev()
end, { desc = "Swap prev node" })
map("n", "<c-h>", function()
	require("tree-climber").swap_next()
end, { desc = "Swap next node" })
map("n", "<c-h>", function()
	require("tree-climber").swap_prev()
end, { desc = "Swap prev node" })

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
	return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true })
map("i", "<PageDown>", function()
	return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true })
map("i", "<A-[>", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true })

-- Ollama
map("n", "<leader>oo", "<cmd><c-u>lua require('ollama').prompt()<cr>", { desc = "Show prompts" })
map("n", "<leader>og", "<cmd><c-u>lua require('ollama').prompt('Generate_Code')<cr>", { desc = "Generate Code" })
map("v", "<leader>os", "<cmd><c-u>lua require('ollama').prompt('Simplify_Code')<cr>", { desc = "Simplify Code" })
map("v", "<leader>op", "<cmd><c-u>lua require('ollama').prompt('Optimize_Code')<cr>", { desc = "Optimize Code" })
map("v", "<leader>oe", "<cmd><c-u>lua require('ollama').prompt('Explain_Code')<cr>", { desc = "Explain Code" })
map("v", "<leader>oc", "<cmd><c-u>lua require('ollama').prompt('Add_Comments')<cr>", { desc = "Add Comments" })

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

-- Go
map("n", "<leader>gf", "<cmd>GoFillStruct<cr>", { desc = "Go fill struct" })
map("n", "<leader>ga", "<cmd>GoAddTag<cr>", { desc = "Go add tags" })
map("n", "<leader>gr", "<cmd>GoRmTag<cr>", { desc = "Go remove tags" })
map("n", "<leader>gm", "<cmd>GoModTidy<cr>", { desc = "Go mod tidy" })
map("n", "<leader>gt", "<cmd>GoAddAllTest -bench<cr>", { desc = "Go add tests" })

-- Git Conflict
map("n", "<leader>gc", "<cmd>GitConflictListQf<cr>", { desc = "Git conflict" })

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
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search Todos" })

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
map("v", "<A-Up>", ":move-2<cr>gv=gv", { desc = "Move block up" })
map("v", "<A-Down>", ":move'>+<cr>gv=gv", { desc = "Move block down" })

-- Jump between windows + close terminal
map("n", "<Tab>", "<C-w>w", { desc = "Jump to next window" })
map("n", "<S-Tab>", "<C-w>W", { desc = "Jump to previous window" })

-- Extras
map("i", "<A-BS>", "<C-w>", opts) -- delete word
map("i", "<C-x>", "<Esc>ddi", opts) -- delete line
map("i", "<C-c>", "<Esc>yyi", opts) -- copy line
map("i", "<C-.>", "<Esc>pi", opts) -- paste line
map("n", "<C-d>", "yyp", opts) -- duplicate line
map("n", "+", "<C-a>", opts) -- increment
map("n", "-", "<C-x>", opts) -- decrement
map("n", "++", "O<Esc>j", opts) -- newline below
map("n", "==", "o<Esc>k", opts) -- newline above
map("n", "--", "<cmd>%&<cr>", opts) -- repeat substitution
map("n", "<C-a>", "gg<S-v>G", opts) -- select all
map("n", "<C-x>", "^y$jA<Space><Esc>pkdd", opts) -- paste at end of line

-- Sort lines
map("x", "<leader>sl", ":sort<CR>", { desc = "Sort lines" })
map("x", "<leader>sr", ":sort!<cr>", { desc = "Sort lines reverse" })
map("x", "<leader>su", ":sort u<cr>", { desc = "Sort unique lines" })

-- Autocomplete when searching
--map("c", "<tab>", "<C-r><C-w>")

-- Visual --
map("v", "p", "\"_dP", opts)
map("v", "q", "<Esc>", opts)
