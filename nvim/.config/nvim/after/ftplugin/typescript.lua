-- local utils = require("utils")

vim.bo.tabstop = 2 -- number of visual spaces per TAB
vim.opt_local.shiftwidth = 2 -- number of spaces to use for autoindent
vim.opt_local.expandtab = true -- expand tab to spaces so that tabs are spaces

-- vim.api.nvim_create_user_command("Compile", function()
-- 	local src = vim.fn.expand("%:p:~")
-- 	utils.Compile("node", src)
-- end, { nargs = 0 })
