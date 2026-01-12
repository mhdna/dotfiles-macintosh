-- vim.keymap.set("n", "<M-n>", "]]", { silent = true, buffer = 0 })
-- vim.keymap.set("n", "<M-p>", "[[", { silent = true, buffer = 0 })

-- Shortcuts for creating markdown "title" lines and others.
vim.opt_local.wrap = true
vim.cmd([[
	map  <Leader>h1   <ESC>yyp:keeppatterns  s/./=/g<CR>o<CR>
	map  <Leader>h2   <ESC>yyp:keeppatterns  s/./-/g<CR>o<CR>
	nmap  <M-b>   siW*.
	nmap  <M-i>   siW*
	]])
