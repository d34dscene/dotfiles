local o = vim.opt
local g = vim.g

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
o.hlsearch = false -- Highlight all search matches
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
