local wezterm = require "wezterm"
local keybindings = require "keybindings"
local config = {}

-- Provide clearer error messages ---------------------------------------------
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config ---------------------------------------------------------------------
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 150
config.initial_rows = 32
config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"
config.scrollback_lines = 10000

keybindings.apply_to_config(config)

return config
