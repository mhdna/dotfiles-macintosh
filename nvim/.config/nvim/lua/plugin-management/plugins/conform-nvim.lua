local prettierd = "prettierd"

local ignored_servers = {
	"html",
}

--- @param client vim.lsp.Client
local function formatter_filter(client)
	return not vim.list_contains(ignored_servers, client.name)
end

-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	-- enabled = false,
	--- @type conform.setupOpts
	opts = {
		formatters_by_ft = {
			astro = { prettierd },
			cs = { "csharpier", "trim_newlines" },
			css = { prettierd },
			-- fish = { "fish_indent" },
			html = { prettierd },
			-- java = { "google-java-format" },
			javascript = { prettierd },
			javascriptreact = { prettierd },
			jq = { "jq" },
			json = { prettierd },
			jsonc = { prettierd },
			less = { prettierd },
			lua = { "stylua" },
			markdown = { "injected", "markdownlint" },
			ocaml = { "ocamlformat" },
			query = { "format-queries" },
			razor = { prettierd, "trim_newlines" },
			sass = { prettierd },
			scss = { prettierd },
			sh = { "shfmt" },
			svelte = { prettierd },
			tex = { "latexindent", "trim_newlines", "trim_whitespace" },
			typescript = { prettierd },
			typescriptreact = { prettierd },
			vue = { prettierd },
			-- go = { "goimports", "gofumpt", "golines" },
			python = { "isort", "black" },
			go = { "goimports", "gofmt" },
			xml = { "xmllint", "trim_newlines", "trim_whitespace" },
			yaml = { prettierd },
			["_"] = { "trim_newlines", "trim_whitespace" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters = {
			shfmt = {
				prepend_args = { "--indent", "4" },
			},
		},
		format_on_save = function(bufnr)
			if vim.g.enable_autoformat then
				return { filter = formatter_filter, timeout_ms = 10000 }
			end
		end,
	},
	init = function()
		vim.g.enable_autoformat = true

		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({
				async = true,
				filter = formatter_filter,
				range = range,
			})
		end, { bar = true, range = true })

		vim.api.nvim_create_user_command("AutoFormatToggle", function(args)
			vim.g.enable_autoformat = not vim.g.enable_autoformat
		end, {
			desc = "Conform: Toggle autoformat-on-save.",
		})

		vim.keymap.set("n", "<leader>=", ":Format<CR>", {
			desc = "Conform: Format the current buffer.",
		})
		vim.keymap.set("n", "<leader>-", ":AutoFormatToggle<CR>", {
			desc = "Conform: Enable autoformat-on-save.",
		})
	end,
}
