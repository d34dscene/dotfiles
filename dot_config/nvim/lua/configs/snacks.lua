local ok, snacks = pcall(require, "snacks")
if not ok then
	vim.notify("Failed to load snacks", vim.log.levels.ERROR)
	return nil
end

local hydra = [[
 ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆           
   ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       
         ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     
          ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    
         ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   
  ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  
 ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   
⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  
⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ 
     ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     
      ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     
]]

local function lazyStats()
	local stats = require("lazy").stats()
	return {
		count = stats.count,
		loaded = stats.loaded,
		startuptime = math.floor(stats.startuptime * 100 + 0.5) / 100,
		updates = #require("lazy.manage.checker").updated,
	}
end

snacks.setup {
	dashboard = {
		enabled = true,
		preset = {
			header = hydra,
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
				{ icon = " ", key = "c", desc = "Check Health", action = ":checkhealth" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{
				pane = 2,
				icon = " ",
				desc = "Browse Repo",
				padding = 1,
				key = "b",
				action = function()
					snacks.gitbrowse()
				end,
			},
			{ pane = 2, icon = "󱋡 ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{
				pane = 2,
				icon = " ",
				title = "Git Status",
				section = "terminal",
				enabled = function()
					return snacks.git.get_root() ~= nil
				end,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60,
				indent = 3,
			},
			function()
				local stats = lazyStats()
				local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
				local updates = stats.updates > 0 and "  " .. stats.updates .. "" or ""
				return {
					align = "center",
					text = {
						{ " ", hl = "footer" },
						{ version, hl = "nontext" },
						{ "    ", hl = "footer" },
						{ stats.loaded .. "/" .. stats.count, hl = "nontext" },
						{ updates, hl = "special" },
						{ "   󰛕 ", hl = "footer" },
						{ stats.startuptime .. " ms", hl = "nontext" },
						{ "    ", hl = "footer" },
						{ os.date "%d.%m.%Y", hl = "nontext" },
					},
					padding = 1,
				}
			end,
			function()
				local hour = tonumber(vim.fn.strftime "%H")
				local periods = { "evening", "morning", "afternoon", "evening" }
				local part_id = (math.floor((hour + 6) / 8) % 4) + 1
				local username = os.getenv "USER" or os.getenv "USERNAME" or "user"

				return {
					align = "center",
					text = {
						string.format("Good %s, %s", periods[part_id], username),
						hl = "NonText",
					},
				}
			end,
		},
	},
	picker = {
		enabled = true,
		layout = {
			reverse = true,
			layout = {
				box = "horizontal",
				backdrop = false,
				width = 0.8,
				height = 0.9,
				border = "none",
				{
					box = "vertical",
					{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
					{
						win = "input",
						height = 1,
						border = "rounded",
						title = "{title} {live} {flags}",
						title_pos = "center",
					},
				},
				{
					win = "preview",
					title = "{preview:Preview}",
					width = 0.45,
					border = "rounded",
					title_pos = "center",
				},
			},
		},
	},
	input = { enabled = true },
	indent = { enabled = true },
	image = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	scope = { enabled = true },
	statuscolumn = { enabled = true },
	terminal = { enabled = true },
	words = { enabled = true },
}

-- Keymaps
local map = vim.keymap.set

-- # Terminal
map({ "n", "t" }, "\\", function()
	local ft = vim.bo.filetype
	local count = vim.v.count
	if ft == "snacks_terminal" and count == 0 then
		vim.cmd "close"
	else
		require("snacks").terminal.toggle(nil, { count = count })
	end
	-- Reset count
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
end, { desc = "Toggle terminal" })

-- # Git
map("n", "<leader>go", function()
	require("snacks").gitbrowse.open()
end, { desc = "Open in repository" })
map("n", "<leader>gb", function()
	require("snacks").git.blame_line()
end, { desc = "Blame line" })

-- # Buffer
map("n", "qe", function()
	vim.cmd "wa"
	require("snacks").bufdelete.other()
end, { desc = "Close other buffers" })

-- # Picker
map("n", "<leader>ff", function()
	require("snacks").picker.smart()
end, { desc = "Find Files" })
map("n", "<leader>fu", function()
	require("snacks").picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fw", function()
	require("snacks").picker.grep()
end, { desc = "Grep" })
map("n", "<leader>fb", function()
	require("snacks").picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fs", function()
	require("snacks").picker.git_status()
end, { desc = "Git Status" })
map("n", "<leader>fg", function()
	require("snacks").picker.git_files()
end, { desc = "Git Files" })
map("n", "<leader>fb", function()
	require("snacks").picker.git_branches()
end, { desc = "Git Branches" })
map("n", "<leader>fi", function()
	require("snacks").picker.git_diff()
end, { desc = "Git Diff" })
map("n", "<leader>fo", function()
	require("snacks").picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>fd", function()
	require("snacks").picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>fh", function()
	require("snacks").picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>ft", function()
	require("snacks").picker.todo_comments()
end, { desc = "Todo Comments" })
map("n", "<leader>fn", function()
	require("snacks").picker.notifications()
end, { desc = "Todo Comments" })
