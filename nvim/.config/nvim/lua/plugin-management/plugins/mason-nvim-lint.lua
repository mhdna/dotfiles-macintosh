-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"rshkarin/mason-nvim-lint",
	enabled = false,
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-lint",
	},
}
