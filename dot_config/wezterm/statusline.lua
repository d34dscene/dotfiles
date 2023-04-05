local wezterm = require "wezterm"
local module = {}

-- Fetch the current title and artist
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

local date = wezterm.strftime " %H:%M | %A | %B %d "
local hostname = " " .. wezterm.hostname() .. " "
local music = " " .. out_title .. " - " .. out_artist .. " "

function module.setup_statusline()
	wezterm.on("update-right-status", function(window, _)
		window:set_right_status(wezterm.format {
			{ Foreground = { Color = "#89b4fa" } },
			{ Background = { Color = "#11111b" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#11111b" } },
			{ Background = { Color = "#89b4fa" } },
			{ Text = music },
		} .. wezterm.format {
			{ Foreground = { Color = "#89b4fa" } },
			{ Background = { Color = "#11111b" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#11111b" } },
			{ Background = { Color = "#11111b" } },
			{ Text = " " },
		} .. wezterm.format {
			{ Foreground = { Color = "#f2cdcd" } },
			{ Background = { Color = "#11111b" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#11111b" } },
			{ Background = { Color = "#f2cdcd" } },
			{ Text = date },
		} .. wezterm.format {
			{ Foreground = { Color = "#f2cdcd" } },
			{ Background = { Color = "#11111b" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#11111b" } },
			{ Background = { Color = "#11111b" } },
			{ Text = " " },
		} .. wezterm.format {
			{ Foreground = { Color = "#f38ba8" } },
			{ Background = { Color = "#11111b" } },
			{ Text = "" },
		} .. wezterm.format {
			{ Foreground = { Color = "#11111b" } },
			{ Background = { Color = "#f38ba8" } },
			{ Text = hostname },
		} .. wezterm.format {
			{ Foreground = { Color = "#f38ba8" } },
			{ Background = { Color = "#11111b" } },
			{ Text = "" },
		})
	end)
end

return module
