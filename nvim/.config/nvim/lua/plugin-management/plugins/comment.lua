return {
	"numtostr/comment.nvim",
	event = "VeryLazy",
	config = function()
		require("Comment").setup({
			ignore = "^$", -- do not comment empty lines
		})
	end,
}
