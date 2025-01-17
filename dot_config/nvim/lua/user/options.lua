local o = vim.opt
local g = vim.g

-- General options
o.backup = false -- Disable backup files
o.swapfile = false -- Disable swap files
o.writebackup = false -- Do not create a backup before overwriting a file
o.undofile = true -- Enable persistent undo between sessions
o.termguicolors = true -- Enable 24-bit RGB color in the TUI
o.mouse = "a" -- Enable mouse support for all modes
o.updatetime = 200 -- Faster CursorHold events
o.timeoutlen = 300 -- Faster key sequence completion
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
o.numberwidth = 2 -- Minimum width for line numbers
o.relativenumber = false -- Do not show relative line numbers
o.signcolumn = "yes" -- Always show the sign column
o.statuscolumn = "%=%{&nu?(&rnu && v:relnum?v:relnum:v:lnum):''} %s%*" -- Custom statusline
o.showmode = false -- Do not show the current mode in the command line
o.showtabline = 2 -- Always display the tab line
o.laststatus = 3 -- Global statusline always on
o.ruler = true -- Show cursor position in the command line
o.colorcolumn = "80" -- PEP8 like character limit vertical bar.
o.whichwrap:append "<>[]hl" -- Move to the next line when the cursor reaches the end of the line
o.pumheight = 10 -- Limit popup menu height
o.scrolloff = 8 -- Keep 8 lines above/below cursor
o.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
o.splitbelow = true -- Open horizontal splits below
o.splitright = true -- Open vertical splits right
o.conceallevel = 2 -- Hide markup in markdown files

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

-- Disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

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
