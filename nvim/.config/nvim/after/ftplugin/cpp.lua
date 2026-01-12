vim.opt_local.shiftwidth = 2
-- local utils = require('utils')

-- vim.api.nvim_create_user_command('Compile', function()
--     local src = vim.fn.expand("%:p:~")
--     local exc = vim.fn.expand("%:p:~:r")
--     utils.Compile("g++", "-Wall -Wextra -std=c++11 -O2 " .. src .. " -o " .. exc .. " && " .. exc)
-- end, { nargs = 0 })
