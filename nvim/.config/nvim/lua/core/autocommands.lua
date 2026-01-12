-- local utils = require("utils")

vim.cmd([[
" Return to last edit position when opening files
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
]])

-- highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 150,
			on_macro = true,
		})
	end,
})

-- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
--   pattern = { "*.blade.php", "*.phtml", "*.gohtml" },
--   command = "set filetype=html",
-- })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "Xresources", "xresources" },
	-- pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
	command = "!reload_xresources",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "cronjobs.txt" },
	command = "!crontab - < %",
})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- 	pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
-- 	command = "set filetype=xdefaults",
-- })

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "bm-dirs", "bm-files" },
-- 	command = '!shortcuts | lf -remote "send $id source ~/.config/lf/shortcutrc"',
-- })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	--     pattern = { os.getenv("HOME") .. "/.config/sway/config" },
	--     command = "!swaymsg reload"
	pattern = { vim.loop.fs_realpath(os.getenv("HOME") .. "/.config/i3/config") },
	command = "silent !i3-msg reload",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	--     pattern = { os.getenv("HOME") .. "/.config/sway/config" },
	--     command = "!swaymsg reload"
	pattern = { vim.loop.fs_realpath(os.getenv("HOME") .. "/.config/sway/config") },
	command = "silent !swaymsg reload",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { vim.loop.fs_realpath(os.getenv("HOME") .. "/.config/lf/lfrc") },
	command = 'silent !lf -remote "send $id source ~/.config/lf/lfrc"',
})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = { "*.me", "*.mom", "*.man" },
--     command = "set filetype=groff"
-- })

-- tex settings
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "tex" },
--     callback = function()
--         vim.api.nvim_create_autocmd('BufWritePost', {
--             command = 'silent! execute "!compiler % >/dev/null 2>&1" | redraw!',
--         })
--         vim.api.nvim_create_autocmd('VimLeave', {
--             command = '!texclear %'
--         })
--     end,
-- })

-- Remove trailing whitespace
vim.cmd([[
 	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e
  	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
]])

vim.api.nvim_create_autocmd("CmdWinEnter", {
	callback = function()
		-- -- Do not stick cmp completions when I open the command window
		-- if utils.IsInstalled("cmp") then
		-- 	require("cmp").close()
		-- end
		-- map q to close
		vim.keymap.set("n", "q", ":q!<CR>", { noremap = true, buffer = 0 })
	end,
})

-- Doesn't work with markdown help pages ofcourse
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help" },
	callback = function()
		vim.bo.buflisted = true
		vim.keymap.set("n", "q", ":q!<CR>", { noremap = true, buffer = 0 })
	end,
})

-- disable automatic commenting new lines. Open folds
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "*" },
	command = "set formatoptions-=cro | set foldlevel=99",
})

-- Open markdown files folds and save them
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = "*.md",
	command = "mkview",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = "*.md",
	command = "silent! loadview",
})

-- -- Autoformat
-- -- vim.api.nvim_create_autocmd('FileType', {
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	-- pattern = { 'cpp', 'python', 'go', 'lua', 'html', 'javascript' },
-- 	pattern = { "*.cpp", "*.py", "*.c", "*.go", "*.lua", "*.html", "*.js" },
-- 	-- callback = function()
-- 	--     vim.api.nvim_create_autocmd('BufWritePre', {
-- 	--         buffer = 0,
-- 	command = "Format",
-- 	--     })
-- 	-- end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "sh",
-- 	callback = function()
-- 		vim.api.nvim_create_autocmd("BufWritePost", {
-- 			buffer = 0,
-- 			command = "Format",
-- 		})
-- 	end,
-- })

-- local suckless = { os.getenv("HOME") .. "/.local/src/dwm/config.h", os.getenv("HOME") .. "/.local/src/st/config.h",
--     os.getenv("HOME") .. "/.local/src/dwmblocks/config.h" }
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     pattern = suckless,
--     callback = function()
--         vim.cmd('set filetype=c')
--         vim.cmd('LspStop')
--         local dir = vim.fn.expand('%:p:h')
--         vim.cmd('!sudo make install -C ' .. dir)
--     end
-- })
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = suckless,
--     command = "set filetype=c"
-- })

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "markdown", "org" },
-- 	command = "setlocal wrap",
-- })

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.go", "*.lua", "*.cpp", "*.sh", "*.html", "*.css", "*.jsx", "*.tsx" },
-- 	command = "Format",
-- })
