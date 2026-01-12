-- selene: allow(mixed_table)
--- @type LazyPluginSpec
return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	dependencies = {
		{ "prochri/telescope-all-recent.nvim", config = true },
		"kkharji/sqlite.lua",
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	keys = {
		{
			"<leader>b",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
			desc = "Switch Buffer",
		},
		{ "<leader>:",  "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>f",  "<cmd>Telescope find_files<cr>",      desc = "Find Files" },
		{ "<leader>gf", "<cmd>Telescope git_files<cr>",       desc = "Find Files (git-files)" },
		{ "<leader>r",  "<cmd>Telescope oldfiles<cr>",        desc = "Recent" },
		{
			"<leader>F",
			function()
				require("telescope.builtin").oldfiles({ cwd = vim.uv.cwd() })
			end,
			desc = "Recent (cwd)",
		},
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>",               desc = "Commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>",                desc = "Status" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>",           desc = "Command History" },
		{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>",       desc = "Document Diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<cr>",               desc = "Workspace Diagnostics" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>",                 desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>",                desc = "Search Highlight Groups" },
		{ "<leader>sj", "<cmd>Telescope jumplist<cr>",                  desc = "Jumplist" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>",                   desc = "Key Maps" },
		{ "<leader>sl", "<cmd>Telescope loclist<cr>",                   desc = "Location List" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>",                 desc = "Man Pages" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>",                     desc = "Jump to Mark" },
		{ "<leader>so", "<cmd>Telescope vim_options<cr>",               desc = "Options" },
		{ "<leader>sR", "<cmd>Telescope resume<cr>",                    desc = "Resume" },
		{ "<leader>sq", "<cmd>Telescope quickfix<cr>",                  desc = "Quickfix List" },
		{
			"gs",
			"<cmd>Telescope live_grep<cr>",
			desc = "Live Grep",
		},
		{
			"gS",
			function()
				require("telescope.builtin").live_grep({ cwd = "%:p:h" })
			end,
			desc = "Live Grep - Current dir",
		},
		{
			"gw",
			"<cmd>Telescope grep_string<cr>",
			desc = "Live Grep",
		},
		{
			"<leader>j",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find configs",
		},
	},
	opts = function()
		local actions = require("telescope.actions")
		require("telescope").load_extension("fzf")
		-- require("telescope").load_extension("heading")

		require("telescope").setup({
			defaults = {
				layout_strategy = "vertical",
				sorting_strategy = "ascending",
				results_title = false,
				layout_config = {
					cursor = {
						height = 0.5,
						width = 0.5,
						column_padding = "",
						-- width = { padding = 0 },
						-- height = { padding = 0 },
						-- so important for previews to not hide when window is small or smth
						preview_cutoff = 0,
						preview_width = 0.6,
						sorting_strategy = "ascending",
						prompt_position = "top",
					},
					horizontal = {
						height = 0.7,
						width = 0.6,
						column_padding = "",
						-- width = { padding = 0 },
						-- height = { padding = 0 },
						-- so important for previews to not hide when window is small or smth
						preview_cutoff = 0,
						preview_width = 0.6,
						sorting_strategy = "ascending",
						prompt_position = "top",
					},
					center = {
						height = 0.999,
						preview_cutoff = 40, -- needed in vertical
						-- prompt_position = "bottom",
						width = 0.9,
					},
					vertical = {
						height = 0.8,
						preview_cutoff = 0, -- needed in vertical
						prompt_position = "bottom",
						width = 0.9,
					},
				},
				border = false,
				-- borderchars             = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
				preview = false,
				winblend = -1,
				mappings = {
					n = {
						["<C-c>"] = actions.close,
					},
					i = {
						-- ["<C-c>"] = false,
						["<C-u>"] = false, -- delete to the beginning using C-u
						-- ["<esc>"] = actions.close,
						["<C-j>"] = actions.cycle_history_next,
						["<C-k>"] = actions.cycle_history_prev,
					},
				},
			},
			-- ),
			extensions = {
				fzy_native = {
					override_generic_sorter = false,
					override_file_sorter = true,
				},
			},
			-- heading = {
			-- 	treesitter = true,
			-- 	-- picker_opts = {
			-- 		-- 	layout_config = { width = 0.8, preview_width = 0.5 },
			-- 		-- 	layout_strategy = "horizontal",
			-- 		-- },
			-- 	},
			-- },
		})

		-- vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Search Git Files' })
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = { "markdown" },
		-- 	callback = function()
		-- 		vim.keymap.set("n", "<leader>i", "<cmd>Telescope heading<CR>", { silent = true, buffer = 0 })
		-- 	end,
		-- })
	end,
	-- {"crispgm/telescope-heading.nvim"}
}
