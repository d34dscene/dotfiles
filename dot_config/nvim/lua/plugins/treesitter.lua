local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
	vim.notify("Failed to load treesitter", vim.log.levels.ERROR)
	return nil
end

-- Install core parsers at startup
treesitter.install {
	"bash",
	"c",
	"comment",
	"css",
	"diff",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"html",
	"javascript",
	"json",
	"latex",
	"lua",
	"luadoc",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"scss",
	"svelte",
	"sql",
	"toml",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"xml",
	"yaml",
	"zsh",
}

local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

local ignore_filetypes = {
	"checkhealth",
	"lazy",
	"mason",
	"snacks_dashboard",
	"snacks_notif",
	"snacks_win",
}

-- Auto-install parsers and enable highlighting on FileType
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	desc = "Enable treesitter highlighting and indentation",
	callback = function(event)
		if vim.tbl_contains(ignore_filetypes, event.match) then
			return
		end

		local lang = vim.treesitter.language.get_lang(event.match) or event.match
		local buf = event.buf

		-- Start highlighting immediately (works if parser exists)
		pcall(vim.treesitter.start, buf, lang)

		-- Enable treesitter indentation
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		-- Install missing parsers (async, no-op if already installed)
		treesitter.install { lang }
	end,
})
