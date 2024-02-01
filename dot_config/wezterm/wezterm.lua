local wezterm = require "wezterm"
local keybindings = require "keybindings"
local statusline = require "statusline"
local config = {}

-- Provide clearer error messages ---------------------------------------------
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config ---------------------------------------------------------------------
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"
config.scrollback_lines = 50000
config.check_for_updates = false
config.allow_square_glyphs_to_overflow_width = "Always"
config.font = wezterm.font("Victor Mono", { weight = "Medium" })

keybindings.apply_to_config(config)
statusline.setup_statusline()

return config
