require("lazy").setup("plugin-management.plugins", {
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
	checker = {
		enabled = true,
		notify = false,
	},
	install = {
		missing = true,
		colorscheme = { "vim" },
	},
	ui = {
		border = "none",
		--   browser = require("system-compat").get_browser_command(),
	},
})
