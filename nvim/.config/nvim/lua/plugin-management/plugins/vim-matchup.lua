-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"andymass/vim-matchup",
	enabled = false,
	-- dependencies = "nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	init = function()
		vim.g.matchup_matchparen_offscreen = { method = "" }
	end,
}
