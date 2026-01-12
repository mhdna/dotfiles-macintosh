return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local status_ok, npairs = pcall(require, "nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		npairs.setup({
			enable_bracket_in_quote = false,
		})

		-- npairs.add_rule(Rule("$$", "$$", "tex"))

		-- I didn't find another way to disable for quotes
		-- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		-- 	pattern = { "*" },
		-- 	callback = function()
		-- 		npairs.remove_rule("'")
		-- 		npairs.remove_rule('"')
		-- 	end,
		-- })
		if not status_ok then
			return
		end

		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				enable_check_bracket_line = false,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		})

		-- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
		-- local cmp_status_ok, cmp = pcall(require, "cmp")
		-- if not cmp_status_ok then
		--   return
		-- end
		-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
	end,
}
