-- local lsp_filetypes =
-- 	{ "go", "html", "css", "php", "blade", "json", "javascript", "typescript", "python", "bash", "sh" }

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	enabled = false,
	-- ft = lsp_filetypes,
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
	},
	-- so slow and sticks on the screen sometimes
	-- {
	-- 	-- show lsp hints while you type
	-- 	"ray-x/lsp_signature.nvim",
	-- 	event = "VeryLazy",
	-- 	-- opts = {},
	-- 	config = function()
	-- 		require("lsp_signature").setup({
	-- 			hint_prefix = "",
	-- 			handler_opts = {
	-- 				border = "none", -- double, rounded, single, shadow, none, or a table of borders
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
