local ollama_status_ok, ollama = pcall(require, "ollama")
if not ollama_status_ok then
	return
end

local response_format = "Respond EXACTLY in this format:\n```$ftype\n<your code>\n```"
local actions = require "ollama.actions.factory"

ollama.setup {
	url = "http://127.0.0.1:11434",
	model = "deepseek:latest",
	prompts = {
		Raw = false,
		Modify_Code = false,
		Ask_About_Code = false,
		Add_Comments = {
			prompt = "Add useful comments to the following $ftype code without modifying it. Add your comment above the code line. Don't explain every single line, just the important ones. Do not add comments to error handling lines. Each sentence should be put in a separate line. Keep it short and simple!"
				.. response_format
				.. "\n\n```$ftype\n$sel```",
			action = "replace",
		},
		Simplify_Code = {
			prompt = "Simplify the following $ftype code so that it is both easier to read and understand."
				.. response_format
				.. "\n\n```$ftype\n$sel```",
			action = actions.create_action { display = true, window = "vsplit" },
		},
		Optimize_Code = {
			prompt = "Optimize the following $ftype code to improve its performance without changing its functionality."
				.. response_format
				.. "\n\n```$ftype\n$sel```",
			action = actions.create_action { display = true, window = "vsplit" },
		},
		Debug_Buffer = {
			prompt = "Debug the following $ftype code. Explain the issues and provide the corrected code. Also provide suggestions on how to improve its organization and readability."
				.. "\n\n```$ftype\n$buf```",
			action = actions.create_action { display = true, window = "vsplit" },
		},
	},
}
