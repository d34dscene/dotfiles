local wezterm = require "wezterm"
local keybindings = require "keybindings"
local statusline = require "statusline"
local config = {}

-- Provide clearer error messages ---------------------------------------------
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.launch_menu = {
	{
		label = "Sentinel",
		domain = { DomainName = "SSH:jk" },
	},
	{
		label = "Router",
		domain = { DomainName = "SSH:ub" },
	},
	{
		label = "Fedora",
		args = { "zsh", "-c", "~/.local/bin/distrobox-enter fedora" },
	},
	{
		label = "Ubuntu",
		args = { "zsh", "-c", "~/.local/bin/distrobox-enter ubuntu" },
	},
	{
		label = "Arch",
		args = { "zsh", "-c", "~/.local/bin/distrobox-enter arch" },
	},
}

-- Config ---------------------------------------------------------------------
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.initial_cols = 150
config.initial_rows = 32
config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"
config.scrollback_lines = 10000
config.check_for_updates = false
config.status_update_interval = 5000

keybindings.apply_to_config(config)
statusline.setup_statusline()

return config
