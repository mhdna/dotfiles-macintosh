-- selene: allow(mixed_table)
--- @type LazyPluginSpec
-- local lsp_filetypes =
-- { "go", "html", "css", "php", "blade", "json", "javascript", "typescript", "python", "bash", "sh" }

return {
	"williamboman/mason-lspconfig.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	enabled = false,
	-- ft = lsp_filetypes,
	dependencies = { "williamboman/mason.nvim", "saghen/blink.cmp" },
	--- @type MasonLspconfigSettings
	opts = {
		automatic_installation = true,
	},
	config = function()
		local mason_lspconfig = require("mason-lspconfig")
		local servers = {
			clangd = {
				flags = {
					debounce_text_changes = 500,
				},
			},
			ruff = {},
			gopls = {},
			-- solidity = {},
			-- solidity_ls_nomicfoundation = {},
			pyright = {},
			-- pylsp = {
			-- 	settings = {
			-- 		pylsp = {
			-- 			plugins = {
			-- 				pylint = { enabled = true, executable = "pylint" },
			-- 				pyflakes = { enabled = false },
			-- 				pycodestyle = { enabled = false },
			-- 				jedi_completion = { fuzzy = true },
			-- 				pyls_isort = { enabled = true },
			-- 				pylsp_mypy = { enabled = true },
			-- 			},
			-- 		},
			-- 	},
			-- 	flags = {
			-- 		debounce_text_changes = 200,
			-- 	},
			-- },
			marksman = {},
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			intelephense = {}, -- php
			phpactor = {},
			dockerls = {},
			tailwindcss = {},
			-- emmet_ls = {
			-- 	filetypes = {
			-- 		"css",
			-- 		"eruby",
			-- 		"html",
			-- 		-- "javascript",
			-- 		-- "javascriptreact",
			-- 		"less",
			-- 		"sass",
			-- 		"scss",
			-- 		"svelte",
			-- 		"pug",
			-- 		-- "typescriptreact",
			-- 		"vue",
			-- 	},
			-- 	init_options = {
			-- 		html = {
			-- 			options = {
			-- 				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
			-- 				["bem.enabled"] = true,
			-- 			},
			-- 		},
			-- 	},
			-- },
			-- might be useful with prettier or something
			-- efm = {
			-- 	filetypes = { "python", "cpp", "lua", "javascript" },
			-- 	init_options = { documentFormatting = true },
			-- 	settings = {
			-- 		rootMarkers = { ".git/" },
			-- 		languages = {
			-- 			lua = {
			-- 				{ formatCommand = "lua-format -i", formatStdin = true },
			-- 			},

			-- 			prettier = {
			-- 				formatCommand = 'prettierd "${INPUT}"',
			-- 				formatStdin = true,
			-- 				env = {
			-- 					string.format(
			-- 						"PRETTIERD_DEFAULT_CONFIG=%s",
			-- 						vim.fn.expand("~/.config/nvim/utils/.prettierrc.json")
			-- 					),
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- },
			-- tsserver = {},
			volar = {
				--  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
				--  init_options = {
				-- vue = {
				--   hybridMode = false,
				-- },
				-- },
			},
			-- ts_ls = { },
			-- stimulus_ls = {},
			html = {},
			cssls = {},
		}
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		vim.diagnostic.config({
			virtual_text = false,

			signs = false,
			underline = false,
			--     update_in_insert = true, -- otherwise it updates on insertLeave
			--     severity_sort = false,
		})

		vim.api.nvim_create_user_command("OrganizeImports", function()
			local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
			params.context = { only = { "source.organizeImports" } }

			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
					else
						vim.lsp.buf.execute_command(r.command)
					end
				end
			end
		end, { nargs = 0 })

		-- require("typescript-tools").setup({
		-- 	filetypes = {
		-- 		"javascript",
		-- 		"javascriptreact",
		-- 		"typescript",
		-- 		"typescriptreact",
		-- 		-- "vue",
		-- 	},
		-- 	settings = {
		-- 		capabilities = capabilities,
		-- 		-- root_dir = root_pattern_exclude({
		-- 		-- 	root = { "package.json" },
		-- 		-- 	exclude = { "deno.json", "deno.jsonc" },
		-- 		-- }),
		-- 		single_file_support = false,
		-- 		-- tsserver_plugins = {
		-- 		-- 	"@vue/typescript-plugin",
		-- 		-- },
		-- 	},
		-- })

		-- local sign = ">>"
		-- local signs = { Error = sign, Warn = sign, Hint = sign, Info = sign }

		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		-- end

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				client.server_capabilities.semanticTokensProvider = nil
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local on_attach = function(_, bufnr)
			vim.opt_local.signcolumn = "no"

			local nmap = function(keys, func)
				vim.keymap.set("n", keys, func, { silent = true, buffer = bufnr, noremap = true })
			end

			nmap("<leader>lr", vim.lsp.buf.rename)
			nmap("<leader>li", ":OrganizeImports<CR>:w<CR>")
			nmap("<leader>la", vim.lsp.buf.code_action)

			nmap("gd", vim.lsp.buf.definition)
			nmap("gD", vim.lsp.buf.type_definition)

			nmap("gr", require("telescope.builtin").lsp_references)
			nmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
			-- nmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)
			-- nmap("<leader>s", require("telescope.builtin").treesitter)

			-- See `:help K` for why this keymap
			nmap("<C-]>", vim.lsp.buf.signature_help)
			nmap("<S-k>", vim.lsp.buf.hover)

			-- nmap("<C-Insert>", function()
			-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end)
			-- nmap("<M-Insert>", function()
			-- 	vim.lsp.buf.add_workspace_folder()
			-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end)
			-- nmap("<M-S-Insert>", function()
			-- 	vim.lsp.buf.remove_workspace_folder()
			-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end)
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
				})
			end,
		})
	end,
}
