local wezterm = require "wezterm"

local module = {}

function module.apply_to_config(config)
	-- Key bindings -----------------------------------------------------------
	config.keys = {
		{
			key = "l",
			mods = "ALT",
			action = wezterm.action.ShowLauncher,
		},
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
			action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
		},
		{
			key = "e",
			mods = "ALT",
			action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
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
		{
			key = "P",
			mods = "CTRL",
			action = wezterm.action.ActivateCommandPalette,
		},
	}

	-- Mouse bindings -------------------------------------------------------------
	config.mouse_bindings = {
		{
			event = { Drag = { streak = 2, button = "Left" } },
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
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	}
end

return module
