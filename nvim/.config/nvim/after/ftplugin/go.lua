-- local utils = require("utils")

-- -- vim.bo.tabstop = 4 -- number of visual spaces per TAB
-- -- vim.opt.shiftwidth = 4 -- number of spaces to use for autoindent
-- -- vim.opt.expandtab = false -- expand tab to spaces so that tabs are spaces

-- vim.api.nvim_create_user_command("Compile", function()
-- 	local src = vim.fn.expand("%:p:~")
-- 	utils.Compile("go", "run " .. src)
-- end, { nargs = 0 })
