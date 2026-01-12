-- local lsp_filetypes =
-- { "go", "html", "css", "php", "blade", "json", "javascript", "typescript", "python", "bash", "sh" }
return {

	"williamboman/mason.nvim",
	enabled = false,
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	-- ft = lsp_filetypes,
	opts = {
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
	},
}
