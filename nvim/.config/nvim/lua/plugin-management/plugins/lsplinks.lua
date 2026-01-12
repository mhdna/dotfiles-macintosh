-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"icholy/lsplinks.nvim",
	enabled = false,
	config = function()
		local lsplinks = require("lsplinks")
		lsplinks.setup()
		vim.keymap.set("n", "gx", lsplinks.gx, {
			desc = "LSPLINKS: Open the current filepath or URL at cursor.",
		})
	end,
}
