local wezterm = require "wezterm"
local module = {}

function module.setup_statusline()
	wezterm.on("update-right-status", function(window, _)
		-- update-right-status calls function every second
		local music = "󰎈 "
		local ok, metadata, _ = wezterm.run_child_process {
			"playerctl",
			"metadata",
			"-i",
			"chromium",
			"--format",
			"{{ artist }} - {{ title }}",
		}
		if ok then
			music = "󰎈 " .. metadata:gsub("[\n\r]", "") .. " "
		end
		local date = wezterm.strftime " %H:%M | %A | %B %d "
		local hostname = " " .. wezterm.hostname() .. " 󰊠 "

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
