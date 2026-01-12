return {
	"godlygeek/tabular",
	event = "VeryLazy",
	config = function()
		vim.keymap.set({ "v", "n" }, "<leader>t<space>", ":Tabularize / <CR>")
		vim.keymap.set({ "v", "n" }, "<leader>t=", ":Tabularize /=<CR>")
		vim.keymap.set("n", "<leader>t:", "<cmd>Tabularize /:\zs<CR>")
		vim.keymap.set("v", "<leader>t:", ":Tabularize /:<CR>")
		vim.keymap.set({ "v", "n" }, "<leader>t,", ":Tabularize /,<CR>")
	end,
}
