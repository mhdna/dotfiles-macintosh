-- https://github.com/neovim/neovim/discussions/24405colorsche
local M = {}

function modify_hl(ns, name, changes)
  local def = vim.api.nvim_get_hl(ns, { name = name, link = false })
  vim.api.nvim_set_hl(ns, name, vim.tbl_deep_extend("force", def, changes))
end

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

function RemoveBackground()
  vim.cmd "highlight Normal guibg=None ctermbg=None"
  vim.cmd "        highlight! EndOfBuffer guibg=None "
  vim.cmd "highlight EndOfBuffer guibg=None"
  -- vim.cmd("highlight NormalFloat guibg=None ctermbg=None")
end

function Gruvbox()
  require("gruvbox").setup {
    -- transparent_mode = true,
    contrast = "", -- can be "hard", "soft" or empty string
    overrides = {
      -- 	-- 	WildMenu = { fg = "#ff9900" },
      -- Normal = { bg = "#1d1d1d" },
      -- Normal = { bg = "None" },
      -- 	-- 	TelescopeNormal = { bg = "#222222" },
    },
  }
  vim.cmd "colorscheme gruvbox"
  vim.cmd "highlight WarningMsg guibg=darkyellow guifg=black"
  -- vim.g.gruvbox_baby_transparent_mode = 1
  -- vim.cmd("colorscheme gruvbox-baby")
end

function matrix()
  vim.opt.termguicolors = false
  vim.cmd "colorscheme green"
  vim.cmd [[
		highlight Normal guibg=None ctermbg=None
		highlight! Normal guibg=None ctermbg=None guifg=None
		highlight! NormalFloat guibg=black ctermbg=black guifg=white ctermfg=white
		highlight! CursorLine guibg=None ctermbg=None " remove cursorline colors
		" highlight Comment guifg=darkgray ctermfg=darkgray
		highlight! link LineNr Normal
		highlight! link CursorLineNr Normal
		highlight! link DiagnosticSignHint SignColumn
		highlight! link DiagnosticSignError SignColumn
		highlight! link DiagnosticSignWarn SignColumn
		highlight! link DiagnosticSignInfo SignColumn
		highlight! link DiagnosticSignOk SignColumn
		]]
end

function solarized()
  vim.cmd "colorscheme solarized"
end

function Quiet()
  vim.cmd [[
	colorscheme quiet
]]
  vim.api.nvim_set_hl(0, "Comment", { bold = 0 })
  vim.cmd [[
		highlight Normal guibg=None ctermbg=None guifg=None
		highlight NormalFloat guibg=black ctermbg=black guifg=white ctermfg=white
		highlight CursorLine guibg=None ctermbg=None " disable cursorline
		highlight Comment guifg=darkgray ctermfg=darkgray
		highlight link DiagnosticSignHint SignColumn
		highlight link DiagnosticSignError SignColumn
		highlight link DiagnosticSignWarn SignColumn
		highlight link DiagnosticSignInfo SignColumn
		highlight link DiagnosticSignOk SignColumn
		" doesn't help
		" highlight DiagnosticVirtualTextInfo ctermfg=black
		" highlight DiagnosticVirtualTextError ctermfg=black
		" highlight DiagnosticVirtualTextWarn ctermfg=black
		]]
  vim.api.nvim_set_hl(0, "Visual", { bg = "blue", fg = "white" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "black", fg = "white" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "black", fg = "white" })
  vim.api.nvim_set_hl(
    0,
    "IncSearch",
    { underline = 1, bg = "white", fg = "black" }
  )
  vim.api.nvim_set_hl(
    0,
    "Search",
    { underline = 1, bg = "white", fg = "black" }
  )
  vim.api.nvim_set_hl(
    0,
    "Substitute",
    { underline = 1, bg = "white", fg = "black" }
  )
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "black", fg = "white" })
  vim.api.nvim_set_hl(
    0,
    "PmenuSel",
    { underline = 1, bg = "white", fg = "black" }
  )
  vim.api.nvim_set_hl(0, "WildMenu", { bg = "black", fg = "white" })
  vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "white" })
  vim.api.nvim_set_hl(0, "MatchParen", { fg = "black", bg = "darkgrey" })
  -- vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "black", bg = "darkgreen" })
  RemoveBackground()
end

function Brown()
  local dark_theme = "kanagawa-dragon"
  vim.cmd("colorscheme " .. dark_theme)
  vim.cmd [[highlight Normal guibg=#221a0f
	highlight WinSeparator guibg=gray
	]]
end

function monokai()
  -- monokai
  require("monokai-pro").setup {
    filter = "classic",
  }
  vim.cmd [[
		colorscheme  monokai-pro
]]
end

function Default_Dark()
  local dark_theme = "vim"

  vim.opt.bg = "dark"
  local colors = {
    darkgray = "#222222",
    gray = "#999999",
    brown = "#65411f",
    darkbrown = "#2B1E08",
    darkgreen = "#002200",
    brownish_gray = "#332821",
    beige = "#fbf1c7",
  }

  vim.cmd("colorscheme " .. dark_theme)
  -- disable annoying
  for _, c in ipairs { "TroubleText", "CursorLineSign" } do
    vim.cmd("highlight " .. c .. " guibg=0 ctermbg=0")
  end

  modify_hl(0, "Whitespace", { fg = "#777777" })
  modify_hl(0, "CursorLine", { bg = colors.darkgray })
  modify_hl(0, "CursorColumn", { bg = colors.darkgray })
  modify_hl(0, "IncSearch", { bg = "black", fg = "white" })
  modify_hl(0, "WinSeparator", { fg = "gray", bg = 0 })
  modify_hl(0, "TelescopeBorder", { fg = colors.gray, bg = 0 })
  modify_hl(0, "TelescopePrompt", { fg = colors.darkgray, bg = 0 })

  modify_hl(0, "NonText", { fg = "#888888", bg = 0 }) -- e.g. EOL
  modify_hl(0, "FloatBorder", { fg = "#888888", bg = 0 }) -- e.g. EOL

  vim.cmd [[
		 highlight! link EndOfBuffer	Normal
		 " highlight NormalFloat guibg=None ctermbg=None
		 " highlight! link Whitespace Comment
		 ]]
  -- modify_hl(0, "Comment", { fg = "#777777" })

  vim.o.bg = "dark"
  vim.api.nvim_set_hl(0, "TabLine", { bg = 0 })
  -- vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.white, bg = "blue" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.darkgreen, fg = "white" })
  vim.api.nvim_set_hl(0, "@text.note", { bg = "Yellow", bold = 1 })
  vim.api.nvim_set_hl(0, "@text.danger", { bg = "Red", bold = 1 }) -- E.g. BUG
  vim.api.nvim_set_hl(0, "@text.warning", { bg = "Blue", bold = 1 }) -- E.g. FIX
  vim.api.nvim_set_hl(0, "FIXME", { ctermfg = "Red", bg = "Red" })
  vim.api.nvim_set_hl(0, "BUG", { ctermfg = "Red", bg = "Red" })
  vim.api.nvim_set_hl(0, "Whitespace", { fg = "#222222" })
  -- modify_hl(0, "LineNr", { bg = colors.darkbrown })
  -- modify_hl(0, "CursorLineNr", { bg = colors.darkbrown, fg = "Yellow" })
  -- modify_hl(0, "SignColumn", { bg = colors.darkbrown })
  -- modify_hl(0, "DiagnosticSignError", { bg = colors.darkbrown })
  -- modify_hl(0, "DiagnosticSignWarn", { bg = colors.darkbrown })
  -- modify_hl(0, "DiagnosticSignInfo", { bg = colors.darkbrown })
  -- modify_hl(0, "DiagnosticSignOk", { bg = colors.darkbrown })

  -- -- -- Map a key to trigger the theme toggle
  -- -- vim.api.nvim_set_keymap('n', '<Leader>t', ':lua ToggleTheme()<CR>', { noremap = true, silent = true })

  if dark_theme == "vim" then
    vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.beige, bg = colors.brown })
    vim.api.nvim_set_hl(
      0,
      "PmenuSel",
      { underline = 1, bg = colors.gray, fg = "black" }
    )
    vim.api.nvim_set_hl(0, "CmpItemKind", { fg = colors.beige })
    vim.api.nvim_set_hl(0, "Visual", { fg = colors.beige, bg = colors.brown })
  end

  RemoveBackground()
end

function rose()
  vim.cmd "colorscheme rose-pine"
  vim.cmd [[
			highlight Normal guibg=None ctermbg=None
			highlight NormalFloat guibg=None ctermbg=None
			]]
end

function dracula()
  vim.cmd "colorscheme dracula"
  vim.cmd [[
			highlight Normal guibg=None ctermbg=None
			highlight NormalFloat guibg=None ctermbg=None
			]]
end

function termpot()
  vim.opt.termguicolors = false
  vim.opt.bg = "dark"
  vim.cmd "colorscheme termpot"
  vim.cmd [[
	highlight DiagnosticVirtualTextInfo ctermfg=gray
	highlight NormalFloat guifg=black ctermfg=black ctermbg=white
	highlight Normal ctermbg=black
	" highlight DiagnosticVirtualTextError ctermfg=gray
	" highlight DiagnosticVirtualTextWarn ctermfg=gray
	"   highlight DiagnosticSignHint ctermfg=black ctermbg=white
	"   highlight DiagnosticSignError ctermfg=black ctermbg=white
	"   highlight DiagnosticSignWarn ctermfg=black ctermbg=white
	"   highlight DiagnosticSignInfo ctermfg=black ctermbg=white
	"   highlight DiagnosticSignOk ctermfg=black ctermbg=white
	]]
end

function Zenburn()
  vim.cmd [[
			colorscheme zenburn
			]]
  RemoveBackground()
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "#222222" })
  -- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#222222" })
end

function minimal()
  vim.opt.termguicolors = false
  vim.opt.bg = "dark"
  vim.cmd [[
	"   highlight link DiagnosticSignHint SignColumn
	"   highlight link DiagnosticSignError SignColumn
	"   highlight link DiagnosticSignWarn SignColumn
	"   highlight link DiagnosticSignInfo SignColumn
	"   highlight link DiagnosticSignOk SignColumn
	highlight PmenuSel ctermbg=black ctermfg=white
	highlight link Whitespace Comment
	" highlight FloatBorder  guifg=white ctermfg=white
	highlight NormalFloat guifg=black ctermfg=white ctermbg=black
	highlight DiagnosticVirtualTextInfo ctermfg=black
	highlight DiagnosticVirtualTextError ctermfg=black
	highlight DiagnosticVirtualTextWarn ctermfg=black
]]
end

function Light_Default()
  vim.opt.bg = "light"
  local light_theme = "morning"
  vim.cmd("colorscheme " .. light_theme)
  vim.cmd [[
	highlight Normal guibg=None ctermbg=None
	highlight EndOfBuffer guibg=None ctermbg=None
	" highlight link DiagnosticSignHint SignColumn
	" highlight link DiagnosticSignError SignColumn
	" highlight link DiagnosticSignWarn SignColumn
	" highlight link DiagnosticSignInfo SignColumn
	" highlight link DiagnosticSignOk SignColumn
	" highlight PmenuSel ctermbg=black ctermfg=white
	" highlight link Whitespace Comment
	" highlight FloatBorder  guifg=white ctermfg=white
	" highlight NormalFloat guifg=black ctermfg=white ctermbg=black
	" highlight DiagnosticVirtualTextInfo ctermfg=black
	" highlight DiagnosticVirtualTextError ctermfg=black
	" highlight DiagnosticVirtualTextWarn ctermfg=black
	]]
  for _, c in ipairs { "TroubleText", "CursorLineSign" } do
    vim.cmd("highlight " .. c .. " guibg=0 ctermbg=0")
  end
end

function Boring()
  vim.cmd [[
	colorscheme boring
	highlight! Normal guibg=None ctermbg=None guifg=None
	highlight! NormalFloat guibg=black ctermbg=black guifg=white ctermfg=white
	highlight! CursorLine guibg=None ctermbg=None " remove cursorline colors
	highlight Comment guifg=darkgray ctermfg=darkgray
	highlight! link LineNr Normal
	highlight! link CursorLineNr Normal
	highlight! link DiagnosticSignHint SignColumn
	highlight! link DiagnosticSignError SignColumn
	highlight! link DiagnosticSignWarn SignColumn
	highlight! link DiagnosticSignInfo SignColumn
	highlight! link DiagnosticSignOk SignColumn
]]
end

function Hybrid()
  vim.cmd [[let g:hybrid_custom_term_colors = 1
	let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
	colorscheme hybrid
]]
end

function base16()
  vim.cmd "colorschem base16-3024"
  RemoveBackground()
end

function Vscode()
  require("vscode").setup {
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = false,

    -- Enable italic comment
    italic_comments = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
      -- vscLineNumber = "#FFFFFF",
    },

    -- -- -- Override highlight groups (see ./lua/vscode/theme.lua)
    -- group_overrides = {
    -- 	-- this supports the same val table as vim.api.nvim_set_hl
    -- 	-- use colors from this colorscheme by requiring vscode.colors!
    -- 	Normal = { bg = "None" },
    -- },
  }
  vim.cmd.colorscheme "vscode"
end

function PaperColor()
  vim.cmd "colorscheme PaperColor"
end

function M.Dark()
  vim.cmd "set bg=dark" -- to avoid trouble
  -- hybrid()
  -- minimal()
  -- termpot()
  -- Boring()
  -- Quiet()
  -- Zenburn()
  -- rose()
  -- base16()
  -- dracula()
  -- green()
  -- Brown()
  Default_Dark()
  -- PaperColor()
  -- Vscode()
  -- monokai()
  -- matrix()
  -- solarized()
  -- Gruvbox()
  -- vim.cmd('colorscheme vim')
  RemoveBackground()
end

-- causes arabic text to disappear in comments with certain fonts
-- modify_hl(0, "Comment", { italic = true })

function M.Light()
  vim.cmd "set bg=light" -- to avoid trouble
  -- Light_Default()
  Vscode()
  -- Boring()
  -- Quiet()
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "#fefee9" })
end

-- M.Light()
M.Dark()

return M
