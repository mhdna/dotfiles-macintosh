-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	enabled = false,
	config = function()
		require("lualine").setup({
			options = {
				-- icons_enabled = false,
				-- -- 	-- 	-- 	-- 	-- theme = "solarized_dark",
				-- theme = "powerline_dark",
				-- theme = "gruvbox_dark",
				theme = "16color",
			},
			-- sections = {
			-- 	lualine_c = {
			-- 		'lsp_progress'
			-- 	}
			-- }
		})
	end,
	-- dependencies = {
	-- 	"arkav/lualine-lsp-progress"
	-- }
}
