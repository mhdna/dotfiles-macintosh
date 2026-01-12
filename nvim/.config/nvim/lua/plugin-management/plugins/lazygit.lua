return {
	dir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/lua/plugin-management/plugins/lazygit",
	enabled = false,
	config = function()
		vim.keymap.set("n", "<leader>g", "<cmd>lua require('lazygit')()<cr>")
	end,
}
