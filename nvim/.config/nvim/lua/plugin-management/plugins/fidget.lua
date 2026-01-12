-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	enabled = false,
	opts = {
		notification = {
			window = {
				winblend = 0,
			},
		},
		progress = {
			display = {
				done_icon = "Done", -- Icon shown when all LSP progress tasks are complete
			},
		},
	},
}
