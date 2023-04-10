local wezterm = require "wezterm"
local module = {}

local function bubble(text, color)
	return wezterm.format {
		{ Foreground = { Color = color } },
		{ Background = { Color = "#11111b" } },
		{ Text = "" },
	} .. wezterm.format {
		{ Foreground = { Color = "#11111b" } },
		{ Background = { Color = color } },
		{ Text = text },
	} .. wezterm.format {
		{ Foreground = { Color = color } },
		{ Background = { Color = "#11111b" } },
		{ Text = "" },
	} .. wezterm.format {
		{ Foreground = { Color = "#11111b" } },
		{ Background = { Color = "#11111b" } },
		{ Text = " " },
	}
end

function module.setup_statusline()
	local music = "󰎈 "
	local weather = " "
	local hostname = " " .. wezterm.hostname() .. " 󰊠 "

	-- local location = io.popen "curl -s http://ip-api.com/json | jq -r .city"
	-- local wttr_url = "curl -s wttr.in/" .. location:read("*a"):gsub("[\n\r]", "") .. "?format=%C+%t"
	-- location:close()
	-- local wttr = io.popen(wttr_url)
	-- weather = " " .. wttr:read("*a"):gsub("[\n\r]", "") .. " "
	-- wttr:close()

	wezterm.on("update-status", function(window, _)
		local metadata = io.popen "playerctl metadata -i chromium --format '{{ artist }} - {{ title }}'"
		music = "󰎈 " .. metadata:read("*a"):gsub("[\n\r]", "")
		metadata:close()

		local date = wezterm.strftime " %H:%M | %A | %B %d "

		window:set_right_status(bubble(music, "#89b4fa") .. bubble(date, "#f2cdcd") .. bubble(hostname, "#f38ba8"))
	end)
end

return module
