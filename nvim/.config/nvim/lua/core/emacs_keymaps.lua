local emacs = require("emacs-bindings")

if vim.g.loaded_emacs_bindings then
	return
end
vim.g.loaded_emacs_bindings = true
vim.g.emacs_bindings_wordchars = vim.g.emacs_bindings_wordchars or os.getenv("WORDCHARS") or "*?_-.[]~="

vim.keymap.set("i", "<C-n>", "<Down>")
vim.keymap.set("i", "<C-p>", "<Up>")

vim.keymap.set("c", "<M-e>", "<C-f>")

vim.keymap.set({ "i", "c" }, "<c-b>", "<Left>")
vim.keymap.set({ "i", "c" }, "<c-f>", "<Right>")
vim.keymap.set({ "i", "c" }, "<c-a>", "<Home>")
vim.keymap.set({ "i", "c" }, "<c-e>", "<End>")
vim.keymap.set({ "i", "c" }, "<m-b>", emacs.move_word_back)
vim.keymap.set({ "i", "c" }, "<m-f>", emacs.move_word_forward)
vim.keymap.set({ "i", "c" }, "<c-h>", emacs.delete_char_back)
vim.keymap.set({ "i", "c" }, "<c-d>", emacs.delete_char_forward)
vim.keymap.set({ "i", "c" }, "<m-backspace>", emacs.delete_word_back)
vim.keymap.set({ "i", "c" }, "<m-d>", emacs.delete_word_forward)
-- vim.keymap.set({"i", "c"}, "<c-u>", emacs.delete_line_back, {remap = false})
vim.keymap.set({ "i", "c" }, "<c-k>", emacs.delete_line_forward)

-- vim.keymap.set({ "v", "n" }, "<M-u>", "u", { silent = true })
-- vim.keymap.set({ "i" }, "<M-u>", "<Esc>:undo<CR>", { silent = true })
-- vim.keymap.set({ "i" }, "<M-r>", "<C-r>", { silent = true })
-- vim.keymap.set({ "v", "n" }, "<M-r>", "<Esc>:redo<CR>", { silent = true })

-- NOTE my old emacs bindings
-- vim.g.emacs_bindings_wordchars = vim.g.emacs_bindings_wordchars or os.getenv("WORDCHARS") or "*?_-.[]~="
-- local CORE_WORD_CHARS = {
-- 	_ = true,
-- }
-- local function get_word_chars()
-- 	local word_chars = {}
-- 	for core_word_char in pairs(CORE_WORD_CHARS) do
-- 		word_chars[core_word_char] = true
-- 	end
-- 	for i = 1, #vim.g.emacs_bindings_wordchars do
-- 		word_chars[vim.g.emacs_bindings_wordchars:sub(i, i)] = true
-- 	end
-- 	return word_chars
-- end
-- local function feed_term_codes(term_codes)
-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(term_codes, true, false, true), "n", false)
-- end
-- local function get_delete_word_forward_col(line, col)
-- 	local word_chars = get_word_chars()
-- 	local next_char = line:sub(col + 1, col + 1)
-- 	while col < #line and not word_chars[next_char] do
-- 		col = col + 1
-- 		next_char = line:sub(col + 1, col + 1)
-- 	end
-- 	while col < #line and word_chars[next_char] do
-- 		col = col + 1
-- 		next_char = line:sub(col + 1, col + 1)
-- 	end
-- 	return col + 1
-- end
-- local function delete_word_forward()
-- 	local col = vim.fn.getcmdpos()
-- 	local line = vim.fn.getcmdline()
-- 	feed_term_codes(("<Delete>"):rep(get_delete_word_forward_col(line, col) - col))
-- end

-- local function delete_line_forward()
-- 	if vim.fn.mode() == "c" then
-- 		local col = vim.fn.getcmdpos()
-- 		local line = vim.fn.getcmdline()
-- 		feed_term_codes(("<Delete>"):rep(#line - col + 1))
-- 	else
-- 		local _, lnum, col
-- 		do
-- 			local __ERDE_TMP_259__
-- 			__ERDE_TMP_259__ = vim.fn.getpos(".")
-- 			_ = __ERDE_TMP_259__[1]
-- 			lnum = __ERDE_TMP_259__[2]
-- 			col = __ERDE_TMP_259__[3]
-- 		end
-- 		local line = vim.fn.getline(".")
-- 		vim.fn.setline(lnum, line:sub(1, col - 1))
-- 	end
-- end

-- vim.keymap.set({ "i", "c" }, "<M-b>", "<C-Left>", opts)
-- vim.keymap.set({ "i", "c" }, "<M-f>", "<C-Right>", opts)
-- vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", opts)
-- vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", opts)
-- vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", opts)
-- vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", opts)
-- vim.keymap.set({ "i", "c" }, "<C-k>", delete_line_forward)
-- -- vim.keymap.set("c", "<C-k>", "<C->estrpart(getcmdline(),0,getcmdpos()-1)<CR>", opts)
-- vim.keymap.set({ "i", "c" }, "<C-d>", "<Delete>", opts)
-- vim.keymap.set({ "i", "c" }, "<M-d>", delete_word_forward, opts)
