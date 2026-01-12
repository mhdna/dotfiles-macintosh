-- local utils = require("utils")
-- local DiagnosticPrevKey = "<C-p>"
-- local DiagnosticNextKey = "<C-n>"

local opts = { noremap = true }

vim.keymap.set("i", "<M-backspace>", "<C-w>")

vim.keymap.set("n", "Q", "gq")
vim.keymap.set("n", "<F1>", "")

-- vim.keymap.set("n", "<M-a>", "<Esc>mogg<S-v>Gy'ozz", opts)
vim.keymap.set("n", "<M-a>", "<Esc>gg<S-v>G", opts)
-- vim.keymap.set("c", "<C-g>", "<C-c>")
vim.keymap.set("n", "<C-c>", "<Esc>")

vim.keymap.set("i", "<M-n>", "<C-n>")
vim.keymap.set("i", "<M-p>", "<C-p>")

vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "-", ":term lf %<CR>i", { noremap = true, silent = true })
-- vim.keymap.set("n", "-", ":Ex<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>W", ":w ", opts)
vim.keymap.set("n", "<leader>E", ":e `which `<Left>", opts)

function ToggleSystemClipboard()
	local current = vim.opt.clipboard:get()
	if vim.tbl_contains(current, "unnamedplus") then
		vim.opt.clipboard:remove("unnamedplus")
		print("Clipboard: unnamedplus disabled")
	else
		vim.opt.clipboard:append("unnamedplus")
		print("Clipboard: unnamedplus enabled")
	end
end

vim.api.nvim_set_keymap("n", "<leader>c", ":lua ToggleSystemClipboard()<CR>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>b", ":b ", opts)
-- vim.keymap.set("n", "<leader>U", ":MasonUpdate<CR>:Lazy update<CR>", opts)
vim.keymap.set("n", "<leader>U", ":Lazy update<CR>", opts)

vim.keymap.set("n", "<leader>e", "siW", { silent = true })

-- vim.keymap.set('i', '<c-u>', '<esc>d^i')

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Perform dot commands over visual blocks
vim.keymap.set("v", ".", ":normal .<CR>", opts)

-- copy to clipboard
-- vim.keymap.set("n", "<leader>y", '"*y', opts)
-- vim.keymap.set("n", "<leader>Y", '"*y$', opts)

-- Copy to clipboard in visual mode
-- vim.api.nvim_set_keymap("n", "<M-y>", '"+y', { noremap = true, silent = true }) -- doesn't work in Emacs, so I don't want conflicts
vim.api.nvim_set_keymap("v", "<M-y>", '"+y', { noremap = true, silent = true })
-- Paste from clipboard in visual mode
-- vim.api.nvim_set_keymap("v", "<M-S-y>", '"+p', { noremap = true, silent = true })

-- repeat substituion in mode
vim.keymap.set("v", "&", ":&&<CR>", opts)

vim.keymap.set("n", "<backspace>", ":Arabic<CR>", opts)
-- vim.keymap.set({ "i", "v" }, "<M-backspace>", "<Esc>:Arabic<CR>li", opts)
vim.keymap.set("n", "<Leader>m", ':call mkdir(expand("%:p:h"), "p")<CR>', opts)
-- vim.keymap.set("n", "<C-k>", "<c-w>k", opts)
-- vim.keymap.set("n", "<C-j>", "<c-w>j", opts)
-- vim.keymap.set("n", "<C-h>", "<c-w>h", opts)
-- vim.keymap.set("n", "<C-l>", "<c-w>l", opts)
-- vim.keymap.set("n", "<C-S-k>", "<c-w>+", opts)
-- vim.keymap.set("n", "<C-S-j>", "<c-w>-", opts)
-- vim.keymap.set("n", "<C-S-h>", "<c-w><", opts)
-- vim.keymap.set("n", "<C-S-l>", "<c-w>>", opts)

vim.keymap.set("n", "<leader>o", ":!opout <c-r>%<CR><CR>", opts)
vim.keymap.set("n", "<leader>o", ":!opout <c-r>%<CR><CR>", opts)

-- copy file paths
vim.keymap.set("n", "yp", '<cmd>let @+ = expand("%")<cr>', opts)
vim.keymap.set("n", "yP", '<cmd>let @+ = expand("%:p")<cr>', opts)
vim.keymap.set("n", "yn", '<cmd>let @+ = expand("%:t")<cr>', opts)
-- exit terminal mode with escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", opts)
-- Substitute with global mode and magic mode enabled (so similar to grep, regex symbols don't need to be escaped)
vim.keymap.set("n", "<S-s>", ":%s//g<left><left>", opts)
vim.keymap.set("v", "<S-s>", ":s//g<left><Left>", opts)
-- vim.keymap.set("n", "<S-s>", ":%smagic//g<left><left>", opts)
-- vim.keymap.set("v", "<S-s>", ":smagic//g<left><Left>", opts)
-- magic mode
-- vim.cmd([[
--     " nnoremap / /\v
--     " vnoremap / /\v
--     " cnoremap %s/ %smagic/
--     " cnoremap \>s/ \>smagic/
--     " nnoremap :g/ :g/\v
--     " nnoremap :g// :g//
-- ]])keymaps

vim.keymap.set("n", "<C-l>", ":nohl<CR>")

-- vim.keymap.set("n", "-", "<Cmd>Explore<CR>")

vim.keymap.set("n", "<leader><leader>x", ":w<CR>:!chmod +x %<CR>", opts)
-- vim.keymap.set("n", "<leader>t", ":filetype detect<CR>", opts)

-- save as super user
vim.cmd([[cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!]])
vim.keymap.set(
	"n",
	"<leader><leader>w",
	":execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<CR>",
	{ noremap = true, buffer = bufnr }
)

-- Formatting
-- vim.keymap.set("n", "<leader>=", ":Format<CR>:w<CR>", { noremap = true, buffer = bufnr, silent = true })

-- vim.keymap.set({ "n", "v" }, "<leader>c", ":w!<CR>:Compile<CR>", { noremap = true, buffer = 0, silent = true })

vim.keymap.set({ "n", "v" }, "<leader><leader>d", ":g/^$/d<CR>", opts)

-- function smart_indent()
-- 	vim.fn.feedkeys([[mz==]])
-- 	local current_line = vim.fn.line(".")
-- 	local indented_line = vim.fn.indent(current_line)

-- 	if vim.fn.matchstr(getline(current_line), "\v^s*$") == "" then
-- 		vim.fn.feedkeys([[`zj]])
-- 	end

-- 	vim.fn.feedkeys([[`zi]])
-- end

-- vim.keymap.set('n', '<Leader>h', '<Cmd>noh<CR>', opts)

-- emacs like tab
-- vim.cmd([[
-- function! SmartIndent()
--     let currPos = getpos(".")
--     " execute "normal! \<Tab>"
--     " let newPos = getpos(".")
--     " if newPos[2] == currPos[2]  " Check if cursor moved horizontally
--     ""    execute "normal! \<C-o>mzi\<Right>"
--     "endif
--     <Esc>
--     normal ==
--     call cursor(currPos[1], currPos[2])
--     i
-- endfunction
-- ]])
-- vim.keymap.set("i", "<Tab>", "<Esc>:call SmartIndent()<CR>a")
-- vim.keymap.set("n", "<Tab>", "==")
-- vim.keymap.set("i", "<Tab>", smart_indent())
-- vim.keymap.set("i", "<Tab>", 'col(\'.\')>1 ? "==" : "<Esc>mzi<Right>"')
-- vim.keymap.set("i", "<Tab>", "getline('.') =~ '^[[:space:]]*$' ? '<Right>' : '==<C-o>==<C-o>'")

-- -- resizing splits
-- vim.keymap.set("n", "=", "3<C-w>>")
-- vim.keymap.set("n", "+", "3<C-w>+")
-- vim.keymap.set("n", "-", "3<C-w><")
-- vim.keymap.set("n", "_", "3<C-w>-")

-- last split
vim.keymap.set("n", "<M-p>", "<C-w><C-p>")

-- search same line
vim.keymap.set("n", "<M-s>", function()
	local line = vim.fn.getline(".")
	vim.cmd("normal! m`") -- Mark the current position
	if vim.fn.search(line) == 0 then
		vim.cmd("normal! ``") -- Go back if no match is found
	end
end, opts)
vim.keymap.set("n", "<M-D>", ":g/^$/d<CR>")
vim.keymap.set("v", "<M-d>", ":DeleteEmptyLinesInVisual<CR>")

-- increase resizing splits ratio
for _, var in ipairs({ "+", "-", ">", "<" }) do
	vim.keymap.set("n", "<C-w>" .. var, "10<C-w>" .. var)
end
vim.keymap.set("n", "<C-w><C-k>", "10<C-w>+")
vim.keymap.set("n", "<C-w><C-j>", "10<C-w>-")
vim.keymap.set("n", "<C-w><C-h>", "10<C-w><")
vim.keymap.set("n", "<C-w><C-l>", "10<C-w>>")

-- vim.keymap.set("n", "<C-w>", "3<C-w>>")
-- vim.keymap.set("n", "+", "3<C-w>+")
-- vim.keymap.set("n", "-", "3<C-w><")
-- vim.keymap.set("n", "_", "3<C-w>-")

-- Key mappings for folding/unfolding in Markdown files
-- vim.keymap.set('n', '<Tab>', function()
-- 	local success, _ = pcall(vim.cmd, "normal! za")
-- 	if not success then
-- 		vim.api.nvim_echo({ { "No fold found.", "WarningMsg" } }, true, {})
-- 	end
-- end, { noremap = true, silent = true })
vim.keymap.set("n", "zO", "zR")
vim.keymap.set("n", "zC", "zM")

-- Warning, might cause your system to totally crash without recovery
-- vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
-- vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })

-- duplicate line
vim.keymap.set("n", "<M-d>", ":t.<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<M-s>", ':s/\\v(\\S+)/"\\1"/g<CR>', {
	noremap = true,
	desc = "Surround each word in selected lines by double quotes.",
})
-- vim.keymap.set(
-- 	"i",
-- 	"<M-d>",
-- 	'<Esc>:let save_cursor=getpos(".")<CR>:call append(line("."), getline("."))<CR>:call setpos(".", save_cursor)<CR>gi',
-- 	{ noremap = true, silent = true }
-- )

-- markdown
-- vim.cmd("nmap <Leader>p :w !mdview -b<CR>")

--  Format columns in visual mode.
vim.cmd([[
	vnoremap <Leader>c :!sed 's/^/-/' \| column -t \| sed 's/^-//'<CR>
	vnoremap <Leader>C :!sed 's/^/-/' \| column -t \| sed 's/^-//'<CR>gv=
	]])

-- " Alt-right/left to navigate forward/backward in the tags stack.
-- vim.cmd([[
-- map <ESC>h <C-T>
-- map <ESC>l <C-]>
-- ]])

-- folding
-- vim.cmd([[
-- 	nmap <M-j> zo
-- 	nmap <M-k> zc
-- 	nmap <M-J> zO
-- 	nmap <M-K> zC
-- 	set foldcolumn=0
-- 	set foldmethod=marker
-- 	set foldlevel=500
-- 	]])

-- toggle statusline
vim.cmd([[
	let s:hidden_all = 0
	function! ToggleHiddenAll()
	if s:hidden_all  == 0
		let s:hidden_all = 1
		set noshowmode
		set noruler
		set laststatus=0
		set noshowcmd
	else
		let s:hidden_all = 0
		set showmode
		set ruler
		set laststatus=3
		set showcmd
		endif
		endfunction
		nnoremap <leader><leader>h :call ToggleHiddenAll()<CR>
		]])

-- vim.keymap.set("n", "<leader>t", colorscheme.ToggleTheme, opts)
-- vim.keymap.set("n", "<leader>t", colorscheme.Dark, opts)

-- vim.cmd([[
-- fun TConfirmQuit()
--     if &modified
--         echo "Throw away changes? (y/n) "
--         let l:c = nr2char(getchar())
--         if l:c == 'y'
--             quit!
--         endif
--         redraw!
--     else
--         quit
--     endif
-- endfun
-- nmap <F2> :w<CR>
-- nmap <F3> :call TConfirmQuit()<CR>
-- nmap <F4> :wq<CR>
-- ]])

-- Diagnostic keymaps
-- if vim.lsp.get_clients() ~= nil then
-- 	vim.keymap.set("n", DiagnosticPrevKey, vim.diagnostic.goto_prev)
-- 	vim.keymap.set("n", DiagnosticNextKey, vim.diagnostic.goto_next)
-- end

vim.keymap.set("n", "<M-k>", vim.diagnostic.open_float)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
