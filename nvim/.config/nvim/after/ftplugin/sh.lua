-- local utils = require("utils")

-- vim.opt_local.makeprg = "shellcheck -f gcc '%'"

-- vim.api.nvim_create_user_command("Compile", function()
-- 	-- save current buffer index
-- 	local current_win = vim.fn.winnr()

-- 	-- Check if the quickfix window is already open
-- 	local is_quickfix_open = false

-- 	-- Iterate over all windows
-- 	for _, winid in ipairs(vim.fn.getwininfo()) do
-- 		if winid["quickfix"] == 1 then
-- 			is_quickfix_open = true
-- 			break
-- 		end
-- 	end
-- 	-- Open the quickfix window using cwindow
-- 	vim.cmd("w | silent make | botright cwindow") -- INFO belowright to split right below this split

-- 	-- Return to the previous split (the file you're editing)
-- 	vim.cmd(current_win .. "wincmd w")
-- 	-- end
-- end, { nargs = 0 })

-- local opts = { noremap = true, silent = true, buffer = 0 }

-- -- vim.keymap.set('n', '<F5>', function() ToggleQuickfix() end, opts)
-- vim.keymap.set("n", "<leader><leader>s", ":source ~/.config/nvim/after/ftplugin/sh.lua<CR>", { noremap = true })
-- vim.keymap.set("n", utils.DiagnosticNextKey, ":cnext<CR>", opts)
-- vim.keymap.set("n", utils.DiagnosticPrevKey, ":cprevious<CR>", opts)
