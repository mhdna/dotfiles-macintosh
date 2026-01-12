return {
	"https://github.com/Yggdroot/LeaderF",
	enabled = false,
	-- dependencies = "https://github.com/youran0715/LeaderF-goimport",
	config = function()
		-------- ctrl-p settings
		vim.cmd([[
" let g:ctrlp_working_path_mode = 'a'
let g:Lf_ShowDevIcons = 0
let g:Lf_HideHelp = 1
let g:Lf_DisableStl = 1
]])
		vim.keymap.set("n", "<leader>k", "<cmd>:Bwipeout<CR>")

		vim.keymap.set("n", "<leader>f", "<cmd>Leaderf file<cr>")
		vim.keymap.set("n", "<leader>b", "<cmd>Leaderf buffer<cr>")
		vim.keymap.set("n", "gs", "<cmd>Leaderf rg<cr>")
		vim.keymap.set("n", "<leader>q", "<cmd>Leaderf quickfix<cr>")
	end,
}
