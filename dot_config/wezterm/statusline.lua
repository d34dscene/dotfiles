local wezterm = require "wezterm"
local module = {}

local date = wezterm.strftime " %H:%M | %A | %B %d "
local hostname = " " .. wezterm.hostname() .. " "

local title = io.popen "playerctl metadata -i chromium title"
local out_title = ""
if title ~= nil then
	out_title = title:read("*a"):gsub("[\n\r]", "")
	title:close()
end

local artist = io.popen "playerctl metadata -i chromium artist"
local out_artist = ""
if artist ~= nil then
	out_artist = artist:read("*a"):gsub("[\n\r]", "")
	artist:close()
end

function module.setup_statusline()
	wezterm.on("update-right-status", function(window, _)
		window:set_right_status(wezterm.format {
			{ Foreground = { Color = "#89b4fa" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#1e1e2e" } },
			{ Background = { Color = "#89b4fa" } },
			{ Text = " " .. out_title .. " - " .. out_artist .. " " },
		} .. wezterm.format {
			{ Foreground = { Color = "#89b4fa" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#1e1e2e" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = " " },
		} .. wezterm.format {
			{ Foreground = { Color = "#f2cdcd" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#1e1e2e" } },
			{ Background = { Color = "#f2cdcd" } },
			{ Text = date },
		} .. wezterm.format {
			{ Foreground = { Color = "#f2cdcd" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#1e1e2e" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = " " },
		} .. wezterm.format {
			{ Foreground = { Color = "#f38ba8" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#1e1e2e" } },
			{ Background = { Color = "#f38ba8" } },
			{ Text = hostname },
		} .. wezterm.format {
			{ Foreground = { Color = "#f38ba8" } },
			{ Background = { Color = "#1e1e2e" } },
			{ Text = "" },
		})
	end)
end

return module
