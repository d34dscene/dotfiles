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
	} .. wezterm.forma {
		{ Foreground = { Color = "#11111b" } },
		{ Background = { Color = "#11111b" } },
		{ Text = " " },
	}
end

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
		local hostname = " " .. wezterm.hostname() .. " 󱚡 "
		local date = wezterm.strftime " %H:%M | %A | %B %d "

		local player =
			io.popen "gdbus introspect --session --dest org.mpris.MediaPlayer2.tidal-hifi --object-path /org/mpris/MediaPlayer2 --only-properties"
		if player then
			local output = player:read "*a"
			local is_playing = string.match(output, "PlaybackStatus%s*=%s*'Playing'")
			player:close()

			if is_playing then
				local title = string.match(output, "'xesam:title':%s*<%s*'([^']*)'>"):gsub("^%s*(.-)%s*$", "%1")
				local artist = string.match(output, "'xesam:artist':%s*<%s*%['([^']*)'%]>"):gsub("^%s*(.-)%s*$", "%1")
				local music = "󰎋 " .. title .. " - " .. artist
				window:set_right_status(slant(music, "#89b4fa") .. slant(date, "#cba6f7") .. slant(hostname, "#f38ba8"))
				--window:set_right_status(bubble(music, "#89b4fa") .. bubble(date, "#f2cdcd") .. bubble(hostname, "#f38ba8"))
			end
		end
		window:set_right_status(slant(date, "#cba6f7") .. slant(hostname, "#f38ba8"))
	end)
end

return module
