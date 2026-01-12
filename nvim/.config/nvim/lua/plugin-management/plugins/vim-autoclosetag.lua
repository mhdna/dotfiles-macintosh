return {
	"alvan/vim-closetag",
	config = function()
		vim.cmd([[
		let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.vue'
			]])
	end,
}
