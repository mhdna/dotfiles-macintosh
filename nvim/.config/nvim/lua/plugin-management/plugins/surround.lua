return {
	"kylechui/nvim-surround",
	version = "*", -- for stability; omit to `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				insert = "<M-s>",
				insert_line = false,
				normal = "s",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "s",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
			},
		})
		vim.keymap.set("n", "<leader>e", "siW", { silent = true })
	end,
}
