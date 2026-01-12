-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"folke/lazydev.nvim",
	enabled = false,
	ft = "lua",
	opts = {
		library = {
			"coerce.nvim/lua/coerce.lua",
			"conform.nvim/lua/conform/types.lua",
			"gitsigns.nvim/lua/gitsigns/status.lua",
			"hydrate.nvim/lua/hydrate/config.lua",
			"lazy.nvim/lua/lazy/types.lua",
			"luvit-meta/library",
			"render-markdown.nvim/lua/render-markdown/init.lua",
			"mason-lspconfig.nvim/lua/mason-lspconfig/settings.lua",
			"mason-nvim-dap.nvim/lua/mason-nvim-dap/settings.lua",
			"mason.nvim/lua/mason-core/package/init.lua",
			"mason.nvim/lua/mason/settings.lua",
			"oil.nvim/lua/oil/types.lua",
		},
	},
}
