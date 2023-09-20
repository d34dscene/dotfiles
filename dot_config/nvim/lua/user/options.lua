local o = vim.opt
local g = vim.g

-- options
o.autoindent = true -- Auto indent
o.autoread = true -- Auto read file when changed
o.backup = false -- creates a backup file
o.clipboard = "unnamedplus" -- Sync with system clipboard
o.colorcolumn = "80" -- Highlight the 80th column
o.completeopt = "menu,menuone,noselect" -- options for insert mode completion
o.cursorline = true -- Highlight the current line
o.expandtab = true -- convert tabs to spaces
o.fileencoding = "utf-8" -- File content encoding for the buffer
o.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
o.hlsearch = false -- Disable highlight on other matching strings when searching
o.ignorecase = true -- Case insensitive searching
o.incsearch = true -- Highlight dynamically as pattern is typed
o.laststatus = 3 -- globalstatus
o.lazyredraw = true -- lazily redraw screen
o.mouse = "a" -- Enable mouse support
o.number = true -- Show numberline
o.preserveindent = false -- Preserve indent structure as much as possible
o.pumheight = 10 -- Height of the pop up menu
o.relativenumber = true -- Show relative numberline
o.scrolloff = 8 -- Number of lines to keep above and below the cursor
o.shiftwidth = 4 -- Number of space inserted for indentation
o.showmode = false -- Disable showing modes in command line
o.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
o.signcolumn = "yes" -- Always show the sign column
o.smartcase = true -- Do not ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.splitbelow = true -- Splitting a new window below the current one
o.splitright = true -- Splitting a new window at the right of the current one
o.statuscolumn = "%=%{&nu?(&rnu && v:relnum?v:relnum:v:lnum):''}%s%*"
o.swapfile = false -- Disable use of swapfile for the buffer
o.tabstop = 4 -- Number of space in a tab
o.termguicolors = true -- Enable 24-bit RGB color in the TUI
o.timeoutlen = 300 -- Length of time to wait for a mapped sequence
o.ttimeoutlen = 10 -- Length of time to wait for a key code
o.undofile = true -- Enable persistent undo
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.whichwrap:append "<>[]hl" -- Go to previous/next line on end/beginning
o.wrap = true -- Wrap lines longer than the width of window

-- Global
g.mapleader = " " -- Leader key
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
