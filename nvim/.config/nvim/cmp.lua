-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		"hrsh7th/cmp-cmdline",

		-- Adds LSP completion capabilities
		"hrsh7th/cmp-nvim-lsp",
		-- "saadparwaiz1/cmp_luasnip",
		-- { "quangnguyen30192/cmp-nvim-ultisnips", after = { "nvim-cmp", "ultisnips" } },
		"hrsh7th/cmp-buffer", -- buffer completions
		"hrsh7th/cmp-path", -- path completions
		-- "onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		-- local lspkind = require("lspkind")

		-- cmp.setup.filetype({ "markdown" }, {
		-- 	completion = {
		-- 		autocomplete = false,
		-- 	},
		-- })

		cmp.setup({
			enabled = function()
				buftype = vim.api.nvim_buf_get_option(0, "buftype")
				if buftype == "prompt" then
					return false
				end
				-- return true
				-- disable auto completion in comments
				local context = require("cmp.config.context")
				-- keep command mode completion enabled when cursor is in a comment
				if vim.api.nvim_get_mode().mode == "c" then
					return true
				else
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end
			end,

			-- window = {
			-- 	completion = { -- rounded border; thin-style scrollbar
			-- 		-- border = "rounded",
			-- 		-- scrollbar = "║",
			-- 		-- winhighlight = "CursorLine:PmenuSel,Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None"
			-- 	},
			-- 	documentation = { -- no border; native-style scrollbar
			-- 		border = "rounded",
			-- 		scrollbar = "",
			-- 		winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
			-- 	},
			-- },
			-- disable preselect (makes cmp behave weirdly with some languages like Go and Rust)
			-- preselect = { cmp.PreselectMode.None },
			formatting = {
				-- format = lspkind.cmp_format({
				-- 	-- mode = "symbol", -- show only symbol annotations
				-- 	maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- 	ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				--
				-- 	-- The function below will be called before any actual modifications from lspkind
				-- 	-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				-- 	before = function(_, vim_item)
				-- 		-- vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
				-- 		return vim_item
				-- 	end,
				-- }),
				-- maximum width
				format = function(entry, vim_item)
					vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
					return vim_item
				end,
			},
			completion = {
				completeopt = "menu,menuone",
				autocomplete = false,
			},
			mapping = {
				-- I keep completion and snippet stuff bound with prefix Meta
				["<CR>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Replace,
								select = false,
							})
						else
							fallback()
						end
					end,
					s = cmp.mapping.confirm({ select = true }),
					-- c = function(fallback)
					--         fallback()
					-- end
				}),
				-- ["<C-n>"] = cmp.mapping(function()
				--         if cmp.visible() then
				--                 cmp.select_next_item()
				--                 -- else
				--                 --     cmp.complete()
				--         end
				-- end, { 'i' }),
				-- ["<M-/>"] = cmp.mapping(function()
				-- 	cmp.complete()
				-- end, { "i" }),
				-- ["<C-p>"] = cmp.mapping(function()
				--         if cmp.visible() then
				--                 cmp.select_prev_item()
				--                 -- else
				--                 --     cmp.complete()
				--         end
				-- end, { 'i' }),

				["<M-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "s" }),
				-- ["<c-y>"] = cmp.mapping(
				--         cmp.mapping.confirm {
				--                 behavior = cmp.ConfirmBehavior.Insert,
				--                 select = true,
				--         },
				--         { "i" }
				-- ),
				["<M-y>"] = cmp.mapping(
					cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					{ "i" }
				),
				["<Tab>"] = cmp.mapping(function(fallback)
					-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
					if cmp.visible() then
						local entry = cmp.get_selected_entry()
						if not entry then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							cmp.confirm()
						end
					else
						-- 	cmp.complete()
						fallback()
					end
				end, { "i", "s", "c" }),

				-- ["<M-CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i" }),
				["<M-n>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.select_next_item()
					else
						cmp.complete()
						-- vim.api.nvim_input("<Down>")
					end
				end, { "i", "c" }),
				["<M-p>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.select_prev_item()
					else
						cmp.complete()
						-- vim.api.nvim_input("<Up>")
					end
				end, { "i", "c" }),
				["<M-l>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.scroll_docs(4)
					end
				end, { "i" }),
				["<M-h>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.scroll_docs(-4)
						-- else
						-- 	vim.api.nvim_input("<Right>")
					end
				end, { "i" }),
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
					-- vim.fn["UltiSnips#Anon"](args.body)
				end,
			},

			sources = {
				-- { name = "nvim_lsp_signature_help" },
				{ name = "path" },
				{
					name = "nvim_lsp",
					max_item_count = 200,
				},
				{ name = "buffer", keyword_length = 1 },
				{ name = "nvim_lua", keyword_length = 1 },
				{ name = "luasnip" }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
		})

		-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline("/", {
			-- mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
			-- view = {
			--     entries = { name = 'wildmenu' }
			-- },
		})

		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			-- mapping = cmp.mapping.preset.cmdline(),
			enabled = true,
			sources = cmp.config.sources({
				{ name = "path" },
				-- { name = "buffer" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
					-- keyword_length = 2,
					-- keyword_pattern = [[\!\@<!\w*]]
				},
			}),
			-- view = {
			--     entries = { name = 'wildmenu' }
			-- },
		})

		-- vim.cmd [[
		--     autocmd CmdWinEnter * lua require('cmp').close()
		--  ]]
	end,
}
