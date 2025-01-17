local cc_status_ok, cc = pcall(require, "codecompanion")
if not cc_status_ok then
	return
end

local buf_utils = require "codecompanion.utils.buffers"
local ollama_url = "https://ollama.mizuchi.dev"

-- Get all models from Ollama API
local function get_models()
	local curl = require "plenary.curl"
	local response = curl.get(ollama_url .. "/v1/models", {
		sync = true,
		headers = {
			["content-type"] = "application/json",
			--["Authorization"] = "Bearer " .. api_key,
		},
	})
	if not response then
		return {}
	end

	local ok, json = pcall(vim.json.decode, response.body)
	if not ok then
		return {}
	end

	local models = {}
	for _, model in ipairs(json.data) do
		table.insert(models, model.id)
	end

	return models
end

cc.setup {
	adapters = {
		ollama = function()
			return require("codecompanion.adapters").extend("ollama", {
				name = "qwen2.5-coder",
				env = {
					url = ollama_url,
					--api_key = "",
				},
				headers = {
					["Content-Type"] = "application/json",
					--["Authorization"] = "Bearer ${api_key}",
				},
				schema = {
					model = {
						default = "qwen2.5-coder:32b",
						choices = get_models(),
					},
					num_ctx = {
						default = 16384,
					},
					num_predict = {
						default = -1,
					},
				},
			})
		end,
	},
	strategies = {
		chat = {
			adapter = "ollama",
			slash_commands = {
				["file"] = {
					callback = "strategies.chat.slash_commands.file",
					description = "Select a file using Telescope",
					opts = {
						provider = "telescope",
						contains_code = true,
					},
				},
			},
			keymaps = {
				send = {
					modes = { n = "ss" },
				},
				close = {
					modes = { n = "q" },
				},
			},
		},
		inline = {
			adapter = "ollama",
		},
		agent = {
			adapter = "ollama",
		},
	},
	prompt_library = {
		["Debug Buffer"] = {
			strategy = "chat",
			description = "Suggest simplifications and optimizations for the current buffer",
			opts = {
				short_name = "debug_buffer",
			},
			prompts = {
				{
					role = "system",
					content = function(context)
						return "You are a seasoned "
							.. context.filetype
							.. " developer with a focus on code optimization and debugging."
					end,
				},
				{
					role = "user",
					content = function(context)
						return "Please review the following code and suggest any simplifications or optimizations to improve readability and performance. Also identify and fix any potential issues, delete or refactor unnecessary code and provide a step-by-step explanation of the changes made:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. buf_utils.get_content(context.bufnr)
							.. "\n```\n\n"
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
							.. " developer with a strong emphasis on code documentation."
					end,
				},
				{
					role = "user",
					content = function(context)
						return "Please generate appropriate documentation comments for the following code, WITHOUT modifying the code. Also no need to output any code, just write the comments separated by newlines:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. buf_utils.get_content(context.bufnr)
							.. "\n```\n\n"
					end,
				},
			},
		},
		["Debug Selection"] = {
			strategy = "chat",
			description = "Debug code selection",
			opts = {
				modes = { "v" },
				short_name = "debug_selection",
				auto_submit = true,
			},
			prompts = {
				{
					role = "system",
					content = function(context)
						return "I want you to act as a senior "
							.. context.filetype
							.. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
					end,
				},
				{
					role = "user",
					content = function(context)
						local text =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return "@rag\nDebug the following code:"
							.. "\n\n```"
							.. context.filetype
							.. "\n"
							.. text
							.. "\n```\n\n Optimize the code, extend it and provide a step-by-step explanation of the changes made."
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
	},
}
