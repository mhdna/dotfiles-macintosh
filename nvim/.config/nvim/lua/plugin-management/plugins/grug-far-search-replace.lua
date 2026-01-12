return {
	"MagicDuck/grug-far.nvim",
	enabled = false,
	config = function()
		require("grug-far").setup({
			-- engine = 'ripgrep' is default, but 'astgrep' can be specified
		})
		vim.keymap.set("n", "<leader>R", "<C-w>o<cmd>GrugFar<CR>", { noremap = true })
	end,
}
