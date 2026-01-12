-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AtomOneLight"
-- config.color_scheme = "Greenscreen (dark) (terminal.sexy)"
-- config.color_scheme = "Solarized (dark) (terminal.sexy)"
-- config.color_scheme = "GruvboxDark"
-- config.color_scheme = "Borland"
config.font = wezterm.font("DejaVu Sans Mono")
-- config.cursor_blink_rate = 800
-- config.default_cursor_style = "BlinkingBlock"
config.line_height = 0.95
config.font_size = 15
-- config.window_background_opacity = 0.8
-- config.line_height = 0.9
-- config.font_size = 20.0
config.term = "xterm-256color"
config.warn_about_missing_glyphs = false
-- config.dpi = 110
-- hide_tab_bar_if_only_one_tab = false
-- config.enable_tab_bar = false
-- config.tab_bar_at_bottom = true
-- config.use_fancy_tab_bar = false
config.window_frame = {
	-- active_titlebar_bg = "#770000",
	-- font = font(font_primary, { bold = true }),
	font_size = 12,
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	{ key = "v", mods = "ALT", action = act.PasteFrom("Clipboard") },
	{ key = "V", mods = "SHIFT|ALT", action = act.PasteFrom("PrimarySelection") },
	{ key = "c", mods = "ALT", action = act.CopyTo("Clipboard") },
}

config.colors = {
	-- 	-- cursor_bg = "#ffffff",
	background = "#000000",
	-- background = "#ffffff",
	-- foreground = "#000000",
	-- 	foreground = "#ffffff",
}
-- {
--   key = ',',
--   mods = 'CMD',
--   action = act.SpawnCommandInNewTab {
--     cwd = os.getenv('WEZTERM_CONFIG_DIR'),
--     set_environment_variables = {
--       TERM = 'screen-256color',
--     },
--     args = {
--       '/usr/local/bin/nvim',
--       os.getenv('WEZTERM_CONFIG_FILE'),
--     },
--   },
-- },

-- and finally, return the configuration to wezterm
return config
