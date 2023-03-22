local o = vim.opt
local g = vim.g

-- options
o.backup = false -- creates a backup file
o.clipboard = "unnamedplus" -- Connection to the system clipboard
o.completeopt = { "menuone", "noselect" } -- options for insert mode completion
o.cursorline = true -- Highlight the current line
o.expandtab = true -- convert tabs to spaces
o.fileencoding = "utf-8" -- File content encoding for the buffer
o.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
o.history = 100 -- Number of commands to remember in a history table
o.ignorecase = true -- Case insensitive searching
o.laststatus = 3 -- globalstatus
o.lazyredraw = true -- lazily redraw screen
o.mouse = "a" -- Enable mouse support
o.number = true -- Show numberline
o.pumheight = 10 -- Height of the pop up menu
o.relativenumber = true -- Show relative numberline
o.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
o.scrolloff = 8 -- Number of lines to keep above and below the cursor
o.tabstop = 4 -- Number of space in a tab
o.shiftwidth = 4 -- Number of space inserted for indentation
o.softtabstop = 0
o.preserveindent = false -- Preserve indent structure as much as possible
o.showmode = false -- Disable showing modes in command line
o.smartcase = true -- Case sensitive searching
o.autoindent = true
o.smartindent = true -- make indenting smarter again
o.signcolumn = "yes" -- Always show the sign column
o.splitbelow = true -- Splitting a new window below the current one
o.splitright = true -- Splitting a new window at the right of the current one
o.swapfile = false -- Disable use of swapfile for the buffer
o.termguicolors = true -- Enable 24-bit RGB color in the TUI
o.updatetime = 100 -- Length of time to wait before triggering the plugin
o.redrawtime = 1500
o.timeout = true
o.ttimeout = true
o.timeoutlen = 300 -- Length of time to wait for a mapped sequence
o.ttimeoutlen = 10
o.undofile = true -- Enable persistent undo
o.wrap = true -- Wrap lines longer than the width of window
o.whichwrap:append "<>[]hl" -- Go to previous/next line on end/beginning
o.autoread = true
o.hlsearch = false
o.incsearch = true
o.colorcolumn = "80"
--o.statuscolumn =
--"%=%{v:relnum?v:relnum:v:lnum}%s%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? \" \" : \" \") : \"  \" }%*"
o.statuscolumn =
	"%=%r%s%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? \" \" : \" \") : \"  \" }%*"
o.foldenable = true
o.foldcolumn = "1"
o.foldlevel = 99
o.foldlevelstart = 99

-- Global
g.mapleader = " "
g.codeium_disable_bindings = 1
g.better_escape_interval = 500
g.highlighturl_enabled = true
g.transparent_enabled = true

-- disable some builtin vim plugins
local default_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(default_plugins) do
	g["loaded_" .. plugin] = 1
end
