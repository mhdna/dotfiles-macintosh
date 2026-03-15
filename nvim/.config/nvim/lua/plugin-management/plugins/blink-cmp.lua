-- local default_sources = { "lsp", "path", "snippets", "buffer" } --"emoji",
-- local cmdline_sources = { "path", "buffer" }

-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	enabled = false,
	dependencies = {
		"L3MON4D3/LuaSnip",
		-- "moyiz/blink-emoji.nvim",
		"rafamadriz/friendly-snippets",
		"mikavilpas/blink-ripgrep.nvim",
		"Kaiser-Yang/blink-cmp-git",
	},
	build = "cargo build --release",
	init = function()
		vim.keymap.set("i", "<C-x><C-u>", function()
			require("blink.cmp").show()
			require("blink.cmp").show_documentation()
			require("blink.cmp").hide_documentation()
		end)
	end,
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		signature = { enabled = false, window = { border = "rounded" } },
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				-- "markdown",
				"ripgrep",
			},
			providers = {
				-- copilot = { async = true, score_offset = 100 },
				lsp = { async = true, score_offset = 99 },
				-- buffer = { score_offset = 98 },
				ripgrep = {
					name = "Ripgrep",
					module = "blink-ripgrep",
					---@type blink-ripgrep.Options
					opts = {
						future_features = {
							issue185_workaround = true, -- temporary fix for serialize error message
						},
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.labelDetails = {
									description = "(rg)",
								}
							end
							return items
						end,
					},
				},
				-- markdown = { name = "RenderMarkdown", module = "render-markdown.integ.blink" },
				-- dap = {
				-- 	name = "dap",
				-- 	module = "blink.compat.source",
				-- 	enabled = function()
				-- 		require("cmp_dap").is_dap_buffer()
				-- 	end,
				-- },
				git = {
					module = "blink-cmp-git",
					name = "Git",

					enabled = function()
						return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
					end,
				},
				-- 	-- 	emoji = {
				-- 	-- 		module = "blink-emoji",
				-- 	-- 		name = "Emoji",
				-- 	-- 	},
			},
		},
		-- signature = { enabled = true },
		completion = {
			documentation = {
				window = { border = "single" },
				-- auto_show = false,
				-- , auto_show_delay_ms = 500
			},
			menu = {
				-- auto_show = false,
				min_width = 10,
				max_height = 10,
				-- auto_show = function(context)
				-- 	return context.mode == "cmdline" or vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				-- end,
				draw = {
					columns = {
						-- { "label", "label_description", gap = 0 },
						{ "label", gap = 0 },
						{ "source_name", gap = 0 },
						-- { "kind", "kind_icon", gap = 1 },
					},
					components = {
						-- kind_icon = {
						-- 	ellipsis = false,
						-- 	text = function(ctx)
						-- 		return ctx.kind_icon .. ctx.icon_gap
						-- 	end,
						-- 	-- highlight = function(ctx)
						-- 	-- 	return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
						-- 	-- 		or "BlinkCmpKind" .. ctx.kind
						-- 	-- end,
						-- },

						source_name = {
							-- width = { max = 4 },
							text = function(ctx)
								return ctx.source_name:sub(1, 3)
							end,
							-- highlight = "BlinkCmpSource",
							highlight = "None",
						},
						label_description = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDescription",
						},
						-- kind = {
						-- 	-- highlight = "None",
						-- 	ellipsis = false,
						-- 	width = { fill = true },
						-- 	text = function(ctx)
						-- 		return ctx.kind
						-- 	end,
						-- 	-- highlight = "BlinkCmpSource",
						-- },
					},
				},
			},
		},
		enabled = function()
			return vim.bo.buftype ~= "prompt" --or require("cmp_dap").is_dap_buffer()
		end,
		keymap = {
			preset = "none",
			["<M-e>"] = { "cancel", "fallback" },
			["<M-n>"] = { "show", "select_next", "fallback" },
			["<M-p>"] = { "show", "select_prev", "fallback" },
			["<M-y>"] = { "accept", "fallback" },
			["<Tab>"] = { "accept", "fallback" },
			-- ["<Cr>"] = { "accept", "fallback" },
			["<M-i>"] = { "show_documentation", "hide_documentation" },
			["<M-u>"] = { "scroll_documentation_up", "fallback" },
			["<M-d>"] = { "scroll_documentation_down", "fallback" },
			-- ["<M-k>"] = { "snippet_forward", "fallback" },
			-- ["<M-j>"] = { "snippet_backward", "fallback" },
		},
		cmdline = {
			enabled = true,
			keymap = {
				preset = "none",
				["<M-n>"] = { "select_next", "fallback" },
				["<M-p>"] = { "select_prev", "fallback" },
				["<M-y>"] = { "accept", "fallback" },
				["<Tab>"] = { "accept", "fallback" },
				["<M-u>"] = { "scroll_documentation_up", "fallback" },
				["<M-d>"] = { "scroll_documentation_down", "fallback" },
				-- ["<M-k>"] = { "snippet_forward", "fallback" },
				-- ["<M-j>"] = { "snippet_backward", "fallback" },
			},
			-- sources = cmdline_sources,
			sources = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Commands
				if type == ":" or type == "@" then
					return { "cmdline" }
				end
				return {}
			end,
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
				},
				menu = {
					auto_show = true, -- Inherits from top level `completion.menu.auto_show` config when not set
					draw = {},
				},
			},
		},
		snippets = { preset = "luasnip" },
	},
}
