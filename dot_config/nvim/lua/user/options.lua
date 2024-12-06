local o = vim.opt
local g = vim.g

-- -- options
-- o.breakindent = true -- Wrap indent to match  line start.
-- o.completeopt = { "menu", "menuone", "noselect" } -- Options for insert mode completion.
-- o.copyindent = true -- Copy the previous indentation on autoindenting.
-- o.cursorline = true -- Highlight the text line of the cursor.
-- o.expandtab = true -- Enable the use of space in tab.
-- o.fileencoding = "utf-8" -- File content encoding for the buffer.
-- o.fillchars = { eob = " " } -- Disable `~` on nonexistent lines.
-- o.foldenable = true -- Enable fold for nvim-ufo.
-- o.foldlevel = 99 -- set highest foldlevel for nvim-ufo.
-- o.foldlevelstart = 99 -- Start with all code unfolded.
-- o.foldcolumn = "1" -- Show foldcolumn in nvim 0.9+.
-- o.ignorecase = true -- Case insensitive searching.
-- o.infercase = true -- Infer cases in keyword completion.
-- o.autoread = true -- Automatically read file when changed from outside.
--
-- o.laststatus = 3 -- Global statusline.
-- o.linebreak = true -- Wrap lines at 'breakat'.
-- o.number = true -- Show numberline.
-- o.preserveindent = true -- Preserve indent structure as much as possible.
-- o.pumheight = 10 -- Height of the pop up menu.
-- o.relativenumber = false -- Show relative numberline.
-- o.shiftwidth = 2 -- Number of space inserted for indentation.
-- o.showmode = false -- Disable showing modes in command line.
-- o.showtabline = 2 -- always display tabline.
-- o.signcolumn = "yes" -- Always show the sign column.
-- o.statuscolumn = "%=%{&nu?(&rnu && v:relnum?v:relnum:v:lnum):''} %s%*" -- Statusline
-- o.smartcase = true -- Case sensitivie searching.
-- o.smartindent = false -- Smarter autoindentation.
-- o.splitbelow = true -- Splitting a new window below the current one.
-- o.splitright = true -- Splitting a new window at the right of the current one.
-- o.tabstop = 2 -- Number of space in a tab.
--
-- o.termguicolors = true -- Enable 24-bit RGB color in the TUI.
-- o.undofile = true -- Enable persistent undo between session and reboots.
-- o.updatetime = 300 -- Length of time to wait before triggering the plugin.
-- o.virtualedit = "block" -- Allow going past end of line in visual block mode.
-- o.writebackup = false -- Disable making a backup before overwriting a file.
-- o.shada = "!,'1000,<50,s10,h" -- Remember the last 1000 opened files
-- o.history = 1000 -- Number of commands to remember in a history table (per buffer).
-- o.swapfile = false -- Ask what state to recover when opening a file that was not saved.
-- o.wrap = true -- Disable wrapping of lines longer than the width of window.
-- o.colorcolumn = "80" -- PEP8 like character limit vertical bar.
-- o.mousescroll = "ver:1,hor:0" -- Disables hozirontal scroll in neovim.
-- o.guicursor = "n:blinkon200,i-ci-ve:ver25" -- Enable cursor blink.
-- o.sidescrolloff = 8 -- Same but for side scrolling.
-- o.selection = "old" -- Don't select the newline symbol when using <End> on visual mode.
-- o.ttyfast = true -- Enable async scrolling in terminal.
-- o.lazyredraw = true -- Do not redraw while executing macros, registers and other commands that have not been typed.
--
-- o.viewoptions:remove "curdir" -- Disable saving current directory with views.
-- o.shortmess:append { s = true, I = true } -- Disable startup message.
-- o.backspace:append { "nostop" } -- Don't stop backspace at insert.
-- o.diffopt:append { "algorithm:histogram", "linematch:60" } -- Enable linematch diff algorithm
-- General options
o.backup = false -- Disable backup files
o.swapfile = false -- Disable swap files
o.writebackup = false -- Do not create a backup before overwriting a file
o.undofile = true -- Enable persistent undo between sessions
o.termguicolors = true -- Enable 24-bit RGB color in the TUI
o.mouse = "a" -- Enable mouse support for all modes
o.linebreak = true

-- Indentation and whitespace
o.expandtab = true -- Convert tabs to spaces
o.shiftwidth = 2 -- Number of spaces inserted for indentation
o.tabstop = 2 -- Number of spaces a tab counts for
o.softtabstop = 2 -- Number of spaces in a tab when editing
o.autoindent = true -- Enable auto-indentation
o.smartindent = true -- Smart indentation (works with some filetypes)
o.fileformats = { "unix", "dos", "mac" } -- Set supported file formats

-- UI options
o.cursorline = true -- Highlight the line under the cursor
o.number = true -- Show line numbers
o.relativenumber = false -- Do not show relative line numbers
o.signcolumn = "yes" -- Always show the sign column
o.statuscolumn = "%=%{&nu?(&rnu && v:relnum?v:relnum:v:lnum):''} %s%*" -- Custom statusline
o.showmode = false -- Do not show the current mode in the command line
o.showtabline = 2 -- Always display the tab line
o.laststatus = 3 -- Global statusline always on
o.ruler = true -- Show cursor position in the command line
o.colorcolumn = "80" -- PEP8 like character limit vertical bar.

-- Search options
o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- Case sensitive if uppercase letters are used
o.hlsearch = true -- Highlight all search matches
o.incsearch = true -- Incremental search highlighting
o.wrap = false -- Do not wrap long lines

-- Global
g.diagnostics_mode = 3
g.url_effect_enabled = true
g.transparent_enabled = true
g.codelens_enabled = true
g.codeactions_enabled = true
g.better_escape_interval = 500
g.semantic_tokens_enabled = true
g.codeium_disable_bindings = 1

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
