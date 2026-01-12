return {
	"L3MON4D3/LuaSnip",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- "saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		-- local types = require("luasnip.util.types")
		local snip = ls.snippet
		-- local node = ls.snippet_node
		-- local text = ls.text_node
		-- local insert = ls.insert_node
		local func = ls.function_node
		-- local choice = ls.choice_node
		-- local dynamicn = ls.dynamic_node

		require("luasnip.loaders.from_vscode").lazy_load()
		-- require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/my_snippets" })
		require("luasnip.loaders.from_lua").load({ paths = "./snippets" })

		-- filetypes to extend from html
		local filetypes = { "blade", "javascriptreact", "typescriptreact", "vue" }
		for _, ft in ipairs(filetypes) do
			ls.filetype_extend(ft, { "html" })
		end

		-- ls.config.set_config({
		-- 	history = false,
		-- 	-- region_check_events = "InsertEnter", -- Do not go back to old snippets
		-- 	updateevents = "TextChanged, TextChangedI",
		-- 	enable_autosnippets = true,
		-- 	-- ext_opts = {
		-- 	--     [types.choiceNode] = {
		-- 	--         active = {
		-- 	--             virt_text = { { "<--", "Error" } },
		-- 	--         },
		-- 	--     },
		-- 	-- },
		-- })

		local date = function()
			Format = "%Y-%m-%d"
			return { os.date(Format) }
		end
		local datet = function()
			Format = "%Y-%m-%d %a %R"
			return { os.date(Format) }
		end

		ls.add_snippets(nil, {
			all = {
				snip({
					trig = "date",
					namr = "Date",
				}, {
					func(date, {}),
				}),
				snip({
					trig = "datet",
					namr = "Date With Time",
				}, {
					func(datet, {}),
				}),
			},
		})

		ls.add_snippets("all", {
			s("ternary", {
				-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
				i(1, "cond"),
				t(" ? "),
				i(2, "then"),
				t(" : "),
				i(3, "else"),
			}),
		})

		ls.add_snippets("lua", {
			s("t", {
				-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
				i(1, "cond"),
				t(" ? "),
				i(2, "then"),
				t(" : "),
				i(3, "else"),
			}),
			s("t", {
				-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
				i(1, "cod"),
				t(" ? "),
				i(2, "then"),
				t(" : "),
				i(3, "else"),
			}),
		})

		ls.add_snippets("python", {
			s("p", {
				-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
				t('print("'),
				i(1, ""),
				t('")'),
			}),
		})

		ls.add_snippets("java", {
			s("sout", {
				-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
				t("System.out.println("),
				i(1, ""),
				t(");"),
			}),
		})
		-- expansion key
		-- this will expand the current item or jump to the next item within the snippet.
		vim.keymap.set({ "i", "s" }, "<M-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			else
				return
			end
		end, { silent = true })

		-- jump backwards
		-- this always moves to the previous item within the snippet
		vim.keymap.set({ "i", "s" }, "<M-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		-- <c-l> is selecting within a list of options.
		-- This is useful for choice nodes (introduced in the forthcoming episode 2)
		vim.keymap.set("i", "<M-S-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end)

		-- vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

		-- shorcut to source my luasnips file again, which will reload my snippets
		-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")

		-- a little fix for luasnip exiting insert mode when pressing backspace
		-- https://github.com/L3MON4D3/LuaSnip/issues/622
		vim.keymap.set("s", "<BS>", "<C-O>s")

		-- fix luasnip (https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1011938524)
		-- vim.api.nvim_create_autocmd('ModeChanged', {
		--     pattern = '*',
		--     callback = function()
		--         if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
		--             and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
		--             and not require('luasnip').session.jump_active
		--         then
		--             require('luasnip').unlink_current()
		--         end
		--     end
		-- })
		-- vim.api.nvim_create_autocmd("ModeChanged", {
		--     pattern = "*",
		--     callback = function()
		--         leave_snippet()
		--     end,
		-- })
	end,
}
