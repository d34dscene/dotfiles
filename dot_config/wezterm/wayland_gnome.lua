local wezterm = require "wezterm"
local module = {}

local function gsettings(key)
	return wezterm.run_child_process { "gsettings", "get", "org.gnome.desktop.interface", key }
end

function module.apply_to_config(config)
	if wezterm.target_triple ~= "x86_64-unknown-linux-gnu" then
		-- skip if not running on linux
		return
	end
	local success, stdout, _ = gsettings "cursor-theme"
	if success then
		config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
	end

	success, stdout, _ = gsettings "cursor-size"
	if success then
		config.xcursor_size = tonumber(stdout)
	end

	config.enable_wayland = true

	if config.enable_wayland and os.getenv "WAYLAND_DISPLAY" then
		success, stdout, _ = gsettings "text-scaling-factor"
	end
end

return module
