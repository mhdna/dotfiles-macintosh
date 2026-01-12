return {
	-- Colorizer seems to be the most performant. I tried others such as nvim-highlight-colors and using it makes scrolling way slower
	"NvChad/nvim-colorizer.lua",
	-- event = "VeryLazy",
	-- enabled = false,
	opts = {
		user_default_options = { names = false },
		--   -- TODO: setup names only for css and html
		--   -- user_default_options = {},
		--   -- filetypes = {
		--   -- 	css = { css = true, names = true },
		--   -- 	html = { css = true, names = true },
		--   -- 	javascript = { css = true, names = true },
		--   -- 	javascriptreact = { css = true, names = true },
		--   -- 	typescript = { css = true, names = true },
		--   -- 	typescriptreact = { css = true, names = true },
		--   -- },
		--   -- filetypes = { "*", user_default_options = { names = false},},
		--   -- { filetypes = { "css", "html" }, user_default_options = { names = true } }
		--   -- { filetypes = { "css", "html" }, user_default_options = { names = true } },
	},
}
