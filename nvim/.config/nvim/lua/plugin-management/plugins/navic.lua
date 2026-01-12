-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"SmiteshP/nvim-navic",
	enabled = false,
	dependencies = "neovim/nvim-lspconfig",
	-- @type Options -- Does not work, conflicts with other type definitions
	opts = {
		-- icons = require("symbols").types,
		highlight = true,
		lsp = {
			preference = {
				"typescript-tools",
			},
		},
		-- separator = " " .. require("symbols").separators.hierarchy.right .. " ",
	},
}
