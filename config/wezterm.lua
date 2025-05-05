-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "tokyonight_night"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.font = wezterm.font("MesloLGS NF")

-- and finally, return the configuration to wezterm
return config
