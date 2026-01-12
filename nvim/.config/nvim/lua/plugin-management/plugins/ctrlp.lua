return {
	"https://github.com/ctrlpvim/ctrlp.vim",
	enabled = false,
	config = function()
		-------- ctrl-p settings
		vim.cmd([[
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
]])
		-- vim.keymap.set("n", "<leader>k", "<cmd>:Bwipeout<CR>")
	end,
}
