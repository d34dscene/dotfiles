local cc_status_ok, cc = pcall(require, "codecompanion")
if not cc_status_ok then
	return
end

local buf_utils = require "codecompanion.utils.buffers"

cc.setup {
	adapters = {
		ollama = function()
			return require("codecompanion.adapters").extend("ollama", {
				schema = {
					model = {
						default = "qwen2.5-coder:32b",
					},
					num_ctx = {
						default = 16384,
					},
					num_predict = {
						default = -1,
					},
				},
				env = {
					url = "https://ollama.mizuchi.dev",
				},
				headers = {
					["Content-Type"] = "application/json",
				},
				parameters = {
					sync = true,
				},
			})
		end,
	},
	strategies = {
		chat = {
			adapter = "ollama",
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
						return "Please review the following code and suggest any simplifications or optimizations to improve readability and performance. Also identify and fix any potential issues:\n\n```"
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
						return "Please generate appropriate documentation comments for the following code, WITHOUT modifying the code:\n\n```"
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

						return "@rag \nDebug the following code:\n\n```"
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
