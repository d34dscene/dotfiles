local wezterm = require "wezterm"
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
--config.enable_tab_bar = false
config.initial_cols = 150
config.initial_rows = 32
config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"
config.scrollback_lines = 10000

-- Key bindings ---------------------------------------------------------------
config.keys = {
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "q",
		mods = "ALT",
		action = wezterm.action.CloseCurrentPane { confirm = false },
	},
	{
		key = "d",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection "Next",
	},
	{
		key = "a",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection "Prev",
	},
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "e",
		mods = "ALT",
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = "s",
		mods = "ALT",
		action = wezterm.action.QuickSelect,
	},
	{
		key = "t",
		mods = "ALT",
		action = wezterm.action.SpawnTab "CurrentPaneDomain",
	},
	{
		key = ",",
		mods = "ALT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = ".",
		mods = "ALT",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

-- Mouse bindings -------------------------------------------------------------
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.Multiple {
			wezterm.action.ExtendSelectionToMouseCursor "Word",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor "Clipboard",
		},
	},
	{
		event = { Up = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom "Clipboard",
	},
	{
		event = { Up = { streak = 2, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.ExtendSelectionToMouseCursor "Line",
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT|ALT",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
