local wezterm = require "wezterm"
local module = {}

local function slant(text, color)
	return wezterm.format {
		{ Foreground = { Color = color } },
		{ Background = { Color = "#11111b" } },
		{ Text = "" },
		--{ Text = "" },
	} .. wezterm.format {
		{ Foreground = { Color = "#11111b" } },
		{ Background = { Color = color } },
		{ Text = text },
	} .. wezterm.format {
		{ Foreground = { Color = color } },
		{ Background = { Color = "#11111b" } },
		{ Text = "" },
		--{ Text = "" },
	}
end

function module.setup_statusline()
	wezterm.on("update-status", function(window, _)
		local domain = window:active_pane():get_domain_name()
		local host = string.match(domain, ":(.+)$") or domain
		local hostname = " " .. wezterm.hostname() .. "@" .. host .. " 󱚡 "
		local date = wezterm.strftime " %H:%M | %A | %B %d "

		window:set_right_status(slant(date, "#cba6f7") .. slant(hostname, "#f38ba8"))
	end)
end

return module
