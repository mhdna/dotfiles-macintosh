return {

	"NeogitOrg/neogit",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		-- "nvim-telescope/telescope.nvim", -- optional
		-- "ibhagwan/fzf-lua", -- optional
		-- "echasnovski/mini.pick", -- optional
		-- "folke/snacks.nvim", -- optional
	},
	config = function()
		vim.keymap.set("n", "<leader>gg", function()
			require("neogit").open({ kind = "tab" })
		end)
	end,
}
