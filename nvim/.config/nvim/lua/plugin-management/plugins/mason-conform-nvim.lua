-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"zapling/mason-conform.nvim",
	enabled = false,
	dependencies = {
		"williamboman/mason.nvim",
		"stevearc/conform.nvim",
	},
}
