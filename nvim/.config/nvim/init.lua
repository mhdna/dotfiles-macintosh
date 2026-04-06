-- vim: foldmethod=marker foldlevelstart=0

-- plugins and packages {{{
local ehandler = require("error-handler").handler

-- -- load plugin infrastructure
vim.opt.termguicolors = true
xpcall(require, ehandler, "plugin-management")

-- xpcall(require, ehandler, "lsp.setup")

require("core.options")
-- require("core.notes")
require("core.keymaps")
require("core.emacs_keymaps")
require("core.colorscheme")
-- require("core.nocolors")
-- require "lf-nvim"
require("core.autocommands")
require("core.usercommands")
require("core.disable_builtin")
