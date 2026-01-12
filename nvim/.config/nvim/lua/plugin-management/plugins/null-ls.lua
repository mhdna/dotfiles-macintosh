return {

	"nvimtools/none-ls.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	enabled = false,
	dependencies = {
		-- "jay-babu/mason-null-ls.nvim",
		-- Adding this as a dependency because some of the default lsps were removed
		-- See https://github.com/nvimtools/none-ls.nvim/discussions/81 for more information
		"nvimtools/none-ls-extras.nvim",
	},
	-- event = { "BufReadPre", "BufNewFile" },
	-- lazy = true,
	config = function()
		local null_ls = require("null-ls")
		local code_actions = null_ls.builtins.code_actions
		local diagnostics = null_ls.builtins.diagnostics
		local formatting = null_ls.builtins.formatting
		local hover = null_ls.builtins.hover
		local completion = null_ls.builtins.completion

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local sources = {
			-- INFO For depricated sources see https://github.com/nvimtools/none-ls.nvim/discussions/81

			-- These come from the configuration for mason-null-ls.nvim
			-- Diagnostics
			diagnostics.hadolint, -- docker linter
			diagnostics.markdownlint,
			hover.dictionary, -- define words in markdown and text files on hover

			formatting.markdownlint,
			formatting.stylua,
			formatting.shfmt,
			-- formatting.shellharden,
			formatting.xmllint,
			formatting.prettierd,

			-- php
			formatting.blade_formatter,
			formatting.phpcsfixer,
			-- diagnostics.phpstan,
			diagnostics.phpcs,

			completion.spell,

			-- go
			diagnostics.golangci_lint,
			formatting.goimports,
			formatting.gofumpt,
			-- formatting.gofmt,
			formatting.golines,
			code_actions.gomodifytags,

			formatting.clang_format,

			-- diagnostics.shellcheck, -- shell script diagnostics
			-- code_actions.shellcheck, -- shell script code actions

			-- python
			-- diagnostics.pylint.with({
			-- 	diagnostics_postprocess = function(diagnostic)
			-- 		diagnostic.code = diagnostic.message_id
			-- 	end,
			-- }),
			formatting.isort,
			-- diagnostics.mypy, -- causes problems on files outside the project
			-- formatting.black,

			-- Formatters based-off the new none-ls-extras plugin
			-- require("none-ls.code_actions.eslint_d"),

			-- require("none-ls.diagnostics.eslint_d"),

			-- require("none-ls.formatting.beautysh"),
			-- require("none-ls.formatting.eslint_d"),
			require("none-ls.formatting.jq"),
		}
		null_ls.setup({
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			on_attach = function(client)
				vim.g.enable_autoformat = true

				function format()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end

				vim.api.nvim_create_user_command("Format", function(args)
					local range = nil
					if args.count ~= -1 then
						local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					end
					-- if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					format()
					-- end
				end, { bar = true, range = true })

				-- vim.api.nvim_create_user_command("AutoFormatToggle", function(args)
				-- 	vim.g.enable_autoformat = not vim.g.enable_autoformat
				-- end, {
				-- 	desc = "Null-ls: Toggle autoformat-on-save.",
				-- })

				vim.keymap.set("n", "<leader>=", ":Format<CR>", {
					desc = "Null-ls: Format the current buffer.",
				})
				-- doesn't work
				-- vim.keymap.set("x", "<leader>=", "<CMD>'<,'>Format<CR>", {
				-- 	desc = "Null-ls: Format the current selection.",
				-- })
				-- vim.keymap.set("n", "<leader>-", ":AutoFormatToggle<CR>", {
				-- 	desc = "Null-ls: Enable autoformat-on-save.",
				-- })
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							if vim.g.enable_autoformat then
								format()
							end
						end,
					})
				end
			end,
		})
	end,
}
