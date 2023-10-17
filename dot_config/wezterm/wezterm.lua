local wezterm = require "wezterm"
local keybindings = require "keybindings"
local statusline = require "statusline"
--local domains = require "domains"
local wayland_gnome = require "wayland_gnome"
local config = {}

-- Provide clearer error messages ---------------------------------------------
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config ---------------------------------------------------------------------
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.initial_cols = 150
config.initial_rows = 32
config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"
config.scrollback_lines = 50000
config.check_for_updates = false
config.font = wezterm.font("Victor Mono", { weight = "Medium" })
config.allow_square_glyphs_to_overflow_width = "Always"
config.xcursor_theme = "Adwaita"

wayland_gnome.apply_to_config(config)
keybindings.apply_to_config(config)
--domains.apply_to_config(config)
statusline.setup_statusline()

return config
