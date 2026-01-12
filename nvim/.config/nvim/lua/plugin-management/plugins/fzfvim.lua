-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"junegunn/fzf.vim",
	enabled = false,
	dependencies = "junegunn/fzf",
	config = function()
		vim.cmd("let g:fzf_layout = { 'down': '40%' }")
		vim.cmd("let g:fzf_history_dir = '~/.local/share/fzf-history'")

		vim.keymap.set("n", "gs", ":Rg<CR>", { silent = true })
		vim.keymap.set("n", "<leader>f", ":FZF --border=none<CR>", { silent = true })
		vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { silent = true })
	end,
}
