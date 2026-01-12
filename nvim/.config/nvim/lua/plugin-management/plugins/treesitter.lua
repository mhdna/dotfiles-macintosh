-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	enabled = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"windwp/nvim-ts-autotag", -- auto rename and close html tags
		-- "nvim-treesitter/nvim-treesitter-refactor",
		-- {
		--   "joosepalviste/nvim-ts-context-commentstring",
		--   config = function()
		--     -- required for Comment.nvim
		--     require("ts_context_commentstring").setup {
		--       enable_autocmd = false,
		--     }
		--   end,
		-- },
		-- "romgrk/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		-- [[ Configure Treesitter ]]
		-- See `:help nvim-treesitter`
		require("nvim-ts-autotag").setup()
		require("nvim-treesitter.configs").setup({
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = {
				-- "org",
				"markdown",
				"vim",
				"vimdoc",
				"comment",
				"query",
				"vue",
				"python",
				"java",
				"go",
				"javascript",
				"typescript",
				"cpp",
				"c",
				"lua",
				"html",
				"tsx",
				"php",
				"php_only",
				"php",
				"dockerfile",
				"git_config",
				"git_rebase",
				"xml",
				"regex",
				"htmldjango",
				"yaml",
				"toml",
				"sql",
				"scss",
				"sxhkdrc",
				-- 'rust',
				"ssh_config",
				"vim",
				"xml",
				"typescript",
				"markdown_inline",
				"json",
			},
			-- markdown = {
			-- 	enable = false,
			-- },

			-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
			-- auto_install = true,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				-- use_languagetree = false,

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				-- disable = { "c", "rust" },
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files

				-- disable = function(lang, buf) -- lang needs to be there
				-- 	local max_filesize = 100 * 1024 -- 100 KB
				-- 	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				-- 	if ok and stats and stats.size > max_filesize then
				-- 		return true
				-- 	end
				-- end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				-- additional_vim_regex_highlighting = false,
				-- additional_vim_regex_highlighting = { "org" }, -- needed for org mode
			},

			-- refactor = {
			-- 	highlight_definitions = { enable = true },
			-- 	clear_on_cursor_move = true,
			-- 	highlight_current_scope = { enable = false },

			-- 	smart_rename = {
			-- 		enable = false,
			-- 		keymaps = {
			-- 			-- mapping to rename reference under cursor
			-- 			smart_rename = "grr",
			-- 		},
			-- 	},

			-- 	navigation = {
			-- 		enable = false,
			-- 		keymaps = {
			-- 			goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
			-- 			list_definitions = "gnD", -- mapping to list all definitions in current file
			-- 		},
			-- 	},
			-- },

			-- better indentation (mhdna: definitely have it)
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-k>",
					node_incremental = "<C-k>",
					node_decremental = "<C-j>",
					scope_incremental = "<M-e>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ib"] = "@block.inner",
						["ab"] = "@block.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["ii"] = "@conditional.inner",
						["ai"] = "@conditional.outer",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					set_jumps = true,
					enable = true, -- whether to set jumps in the jumplist
					goto_previous_start = {
						["<M-k>"] = "@function.outer",
						["<M-[>"] = "@class.outer",
						["<M-S-i>"] = "@conditional.outer",
						["<M-S-l>"] = "@loop.outer",
						["<M-p>"] = "@block.outer",
					},
					goto_next_start = {
						["<M-j>"] = "@function.outer",
						["<M-]>"] = "@class.outer",
						["<M-i>"] = "@conditional.outer",
						["<M-l>"] = "@loop.outer",
						["<M-n>"] = "@block.outer",
					},
					goto_previous_end = {
						["<M-S-k>"] = "@function.outer",
						["<M-S-[>"] = "@class.outer",
						-- ["<M-S-p>"] = "@conditional.outer",
					},
					goto_next_end = {
						["<M-S-j>"] = "@function.outer",
						["<M-S-]>"] = "@class.outer",
						-- ["<M-S-n>"] = "@conditional.outer",
					},
				},
				-- swap = {
				-- 	enable = true,
				-- 	swap_next = {
				-- 		["<M-s>"] = "@parameter.inner",
				-- 	},
				-- 	swap_previous = {
				-- 		["<M-S-s>"] = "@parameter.inner",
				-- 	},
				-- },
			},
			-- autotag = {
			-- 	enable = true,
			-- },
			matchup = {
				enable = true, -- mandatory, false will disable the whole extension
				-- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
			},
		})

		-- context
		-- vim.treesitter.query.set("lua", "context", "") -- disable context for lua
		-- require("treesitter-context").setup { enable = true }
		-- vim.keymap.set({ "n", "v" }, "<M-u>", function()
		--   require("treesitter-context").go_to_context()
		-- end, { silent = true })

		--     config = function()
		--       vim.cmd [[
		--                      hi TreesitterContext guisp=Grey guibg=#333333
		-- " highlight! link TreesitterContext  Visual
		--                      hi TreesitterContextBottom gui=underline
		-- ]]
		--     end

		-- -- Folding Module
		-- vim.opt.foldmethod = "expr"
		-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		-- vim.opt.foldenable = false
		-- vim.cmd("let g:markdown_folding = 1")

		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
				[".*%.html"] = "htmldjango",
				[".*%.html%.jinja"] = "htmldjango",
				[".*%.html%.jinja2"] = "htmldjango",
				[".*%.html%.j2"] = "htmldjango",
			},
		})
		-- vim.keymap.set("n", "[c", function()
		--     require("treesitter-context").go_to_context()
		-- end, { silent = true })

		-- vim.cmd [[ hi TreesitterContext guisp=Grey guibg=#333333
		--                 "hi TreesitterContextBottom gui=underline
		--                 ]]
		-- vim.treesitter.query.set("lua", "context", "")
	end,
}
