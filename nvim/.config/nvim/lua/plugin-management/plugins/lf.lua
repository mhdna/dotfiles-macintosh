return {
	"ptzz/lf.vim",
	dependencies = "voldikss/vim-floaterm",

	init = function()
		vim.cmd([[
		" let g:NERDTreeHijackNetrw = 0 " Add this line if you use NERDTree
		let g:lf_map_keys = 0 " disable builtin keys
		let g:lf_replace_netrw = 1 " Open lf when vim opens a directory
		let g:floaterm_wintype = 'split'
		let g:floaterm_opener = 'edit'
		]])
	end,

	config = function()
		vim.keymap.set("n", "-", "<CMD>LfCurrentFileNewTab<CR>")
		vim.keymap.set("n", "_", "<CMD>LfCurrentDirectoryNewTab<CR>")
	end,
}
