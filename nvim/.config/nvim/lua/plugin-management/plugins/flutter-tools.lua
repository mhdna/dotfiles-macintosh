return {
	"akinsho/flutter-tools.nvim",
	ft = { "dart" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		vim.lsp.document_color.enable(true)
		require("flutter-tools").setup({
			lsp = {
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					analysisExcludedFolders = {
						vim.fn.expand("$HOME/.pub-cache"),
						vim.fn.expand("$HOME/fvm"),
					},
				},
			},
		})
	end,
}
