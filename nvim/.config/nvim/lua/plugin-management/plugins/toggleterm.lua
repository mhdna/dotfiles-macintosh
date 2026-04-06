return {
	"akinsho/toggleterm.nvim",
	config = function()
		local Terminal = require("toggleterm.terminal").Terminal
		local tmux = Terminal:new({
			cmd = "tmux a",
			direction = "float",
			float_opts = {
				border = "bold",
			},
			-- function to run on opening the terminal
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			-- function to run on closing the terminal
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})

		function _tmux_toggle()
			tmux:toggle()
		end

		-- vim.api.nvim_set_keymap("n", "<D-;>", "<cmd>lua _tmux_toggle()<CR>", { noremap = true, silent = true })
		require("toggleterm").setup({
			open_mapping = [[<D-;>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
			direction = "float",
			-- size = 20 | function(term)
			-- 	if term.direction == "horizontal" then
			-- 		return 15
			-- 	elseif term.direction == "vertical" then
			-- 		return vim.o.columns * 0.4
			-- 	end
			-- end,
			-- highlights = {
			-- 	-- highlights which map to a highlight group name and a table of it's values
			-- 	-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
			-- 	Normal = {
			-- 		guibg = "<VALUE-HERE>",
			-- 	},
			-- 	NormalFloat = {
			-- 		link = "Normal",
			-- 	},
			-- 	FloatBorder = {
			-- 		guifg = "<VALUE-HERE>",
			-- 		guibg = "<VALUE-HERE>",
			-- 	},
			-- }
			float_opts = {
				-- The border key is *almost* the same as 'nvim_open_win'
				-- see :h nvim_open_win for details on borders however
				-- the 'curved' border is a custom border type
				-- not natively supported but implemented in this plugin.
				-- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
				-- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
				width = 79,
				-- height = <value>,
				winblend = 0,
			},
		})
	end,
}
