local ok, codecompanion = pcall(require, "codecompanion")
if not ok then
	vim.notify("Failed to load codecompanion", vim.log.levels.ERROR)
	return nil
end

-- Adapters configuration
local function ollama()
	return require("codecompanion.adapters").extend("ollama", {
		name = "ollama",
		env = { url = "https://ollama.mizuchi.dev" },
		schema = {
			model = { default = "qwen3-coder:latest" },
			num_ctx = { default = 16384 },
			num_predict = { default = -1 },
		},
	})
end

local function openrouter()
	return require("codecompanion.adapters").extend("openai_compatible", {
		name = "openrouter",
		env = {
			url = "https://openrouter.ai/api",
			api_key = os.getenv "OPENROUTER_API",
			chat_url = "/v1/chat/completions",
		},
		schema = { model = { default = "anthropic/claude-sonnet-4.5" } },
	})
end

local buf_utils = require "codecompanion.utils.buffers"

codecompanion.setup {
	display = {
		action_palette = { provider = "snacks" },
	},
	adapters = {
		http = {
			ollama = ollama(),
			openrouter = openrouter(),
		},
	},
	strategies = {
		chat = {
			adapter = "openrouter",
			slash_commands = {
				["file"] = {
					callback = "strategies.chat.slash_commands.catalog.file",
					opts = { provider = "snacks" },
				},
				["buffer"] = {
					callback = "strategies.chat.slash_commands.catalog.buffer",
					opts = { provider = "snacks" },
				},
				["image"] = {
					callback = "strategies.chat.slash_commands.catalog.image",
					opts = { provider = "snacks" },
				},
			},
			keymaps = {
				send = {
					modes = {
						n = { "<CR>", "ss" },
						i = "<C-s>",
					},
				},
				close = {
					modes = { n = "q" },
				},
			},
		},
		inline = {
			adapter = "openrouter",
			keymaps = {
				accept_change = {
					modes = { n = "gda" },
				},
				reject_change = {
					modes = { n = "gdr" },
				},
				always_accept = {
					modes = { n = "gdy" },
				},
			},
		},
		cmd = { adapter = "ollama" },
		workflow = { adapter = "ollama" },
	},
	prompt_library = {
		["Refactor Buffer"] = {
			strategy = "chat",
			description = "Suggest simplifications and optimizations for the current buffer",
			opts = { short_name = "refactor_buffer" },
			prompts = {
				{
					role = "system",
					content = function(context)
						return "You are an experienced "
							.. context.filetype
							.. " developer with deep expertise in debugging, optimization, and refactoring. Provide detailed, step-by-step reasoning for each suggestion."
					end,
				},
				{
					role = "user",
					content = function(context)
						return "Review the code below and suggest simplifications, performance improvements, and debugging fixes. For each change, explain why it helps and include revised code snippets when useful:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. buf_utils.get_content(context.bufnr)
							.. "\n```"
					end,
				},
			},
		},
		["Document Buffer"] = {
			strategy = "chat",
			description = "Generate documentation comments for the selected code",
			opts = {
				short_name = "document_buffer",
			},
			prompts = {
				{
					role = "system",
					content = function(context)
						return "You are an expert "
							.. context.filetype
							.. " developer renowned for writing clear and comprehensive documentation."
					end,
				},
				{
					role = "user",
					content = function(context)
						return "Analyze the following code and generate detailed documentation comments ONLY. Do not alter the code; output each comment on a new line:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. buf_utils.get_content(context.bufnr)
							.. "\n```"
					end,
				},
			},
		},
		["Document Selection"] = {
			strategy = "inline",
			description = "Generate documentation comments for the selected code",
			opts = {
				modes = { "v" },
				short_name = "document_selection",
				auto_submit = true,
			},
			prompts = {
				{
					role = "system",
					content = function(context)
						return "You are an expert "
							.. context.filetype
							.. " developer renowned for writing clear and comprehensive documentation."
					end,
				},
				{
					role = "user",
					content = function(context)
						return "Analyze the following code and generate detailed documentation comments ONLY. Do not alter the code; output each comment on a new line:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. buf_utils.get_content(context.bufnr)
							.. "\n```"
					end,
				},
			},
		},
		["Refactor Selection"] = {
			strategy = "chat",
			description = "Refactor and optimize the selected code",
			opts = {
				modes = { "v" },
				short_name = "refactor_selection",
				auto_submit = true,
			},
			prompts = {
				{
					role = "system",
					content = function(context)
						return "You are a senior "
							.. context.filetype
							.. " developer, highly experienced in refactoring and code design. Focus on improving structure, clarity, and performance."
					end,
				},
				{
					role = "user",
					content = function(context)
						local text =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
						return "Refactor the following code to improve readability and efficiency. Explain your changes step-by-step and provide updated code examples:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. text
							.. "\n```"
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
		["Auto-generate git commit message"] = {
			strategy = "inline",
			description = "Generate git commit message for current staged changes",
			opts = {
				mapping = "<LocalLeader>aacm",
				placement = "before|false",
				adapter = {
					name = "openrouter",
					model = "anthropic/claude-haiku-4.5",
				},
			},
			prompts = {
				{
					role = "user",
					contains_code = true,
					content = function()
						return [[You are an expert at following the Conventional Commit specification based on the following diff:
]] .. vim.fn.system "git diff --cached" .. [[

Generate a commit message for me. Follow the below structure:

   [type]: [short description]

   {List of details if necessary using bullets}

Return the code only and no markdown codeblocks. Valid types are: [feat, fix, doc, wip, chore] 
]]
					end,
				},
			},
		},
	},
}

-- Keymaps
local map = vim.keymap.set

map({ "n", "v", "i" }, "<A-\\>", function()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	local is_codecompanion = vim.bo[buf].filetype == "codecompanion"

	if is_codecompanion then
		vim.cmd "CodeCompanionChat Toggle"
		vim.cmd "stopinsert"
	else
		vim.cmd "CodeCompanionChat Toggle"
		vim.cmd "startinsert"
	end
end, { desc = "Code companion chat toggle" })
map({ "n", "v" }, "<A-->", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Code companion chat toggle" })
map({ "n", "v" }, "<leader>ci", "<cmd>CodeCompanion<cr>", { desc = "Inline Prompt" })
map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", { desc = "Code companion actions" })
map("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add visually selected chat" })
map("n", "<leader>cd", "<cmd>CodeCompanion /document_buffer<cr>", { desc = "Document buffer" })
map("n", "<leader>cr", "<cmd>CodeCompanion /refactor_buffer<cr>", { desc = "Refactor buffer" })
map("v", "<leader>cd", "<cmd>CodeCompanion /document_selection<cr>", { desc = "Document selection" })
map("v", "<leader>cr", "<cmd>CodeCompanion /refactor_selection<cr>", { desc = "Refactor selection" })
