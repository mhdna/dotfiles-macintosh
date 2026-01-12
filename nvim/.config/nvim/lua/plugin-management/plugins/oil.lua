return {
	"stevearc/oil.nvim",
	enabled = false,
	config = function()
		require("oil").setup(
			{
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					-- ["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				use_default_keymaps = false,
				-- columns = {
				-- 	-- "icon",
				-- 	{ "permissions", highlight = "Material_SynDecorator" },
				-- },
				win_options = {
					colorcolumn = "",
					signcolumn = "yes:2",
				},
				lsp_file_methods = {
					autosave_changes = true,
				},
			},

			vim.keymap.set("n", "-", require("oil.actions").parent.callback, {
				desc = "Oil: Open parent directory of current buffer.",
			})
		)
	end,
}
