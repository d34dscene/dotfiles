local cc_status_ok, cc = pcall(require, "codecompanion")
if not cc_status_ok then
	return
end

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
		["Debug"] = {
			strategy = "chat",
			description = "Debug code",
			auto_submit = true,
			modes = { "n" },
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
						local buf_utils = require "codecompanion.utils.buffers"

						return "@rag\n/buffer\n"
							.. "Debug, optimize and simplify the following code:\n```"
							.. context.filetype
							.. "\n"
							.. buf_utils.get_content(context.bufnr)
							.. "\n```\n\n"
							.. "Improve it for maintainability, readability and provide a step-by-step explanation of the changes made."
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
		["Debug Selection"] = {
			strategy = "chat",
			description = "Debug code selection",
			auto_submit = true,
			user_prompt = true,
			stop_context_insertion = true,
			modes = { "v" },
			opts = {
				mapping = "<leader>cd",
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
