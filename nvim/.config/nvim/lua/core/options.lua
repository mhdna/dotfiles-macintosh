-- vim.g.loaded_matchparen = 1
local opt = vim.opt

-- opt.lazyredraw = true
-- vim.loader.enable()
-- opt.list = true
-- opt.listchars:append("leadmultispace:...+,trail:.")
-- opt.listchars:append("leadmultispace:...+,trail:.")
-- opt.listchars = { eol = "$", tab = " »" } -- leadmultispace:...+,tab:>-,trail:.
-- opt.listchars:append("tab:|-,eol:↴,precedes:<,extends:>,trail:#,nbsp:%")
-- opt.listchars:append("tab:|-,precedes:<,extends:>,trail:#,nbsp:%")

-- tell vim that my terminal provides bidi support
-- doesn't work great with qterminal (e.g. when lsp turned on with virtual text)
-- opt.termbidi = true

-- opt.pumheight = 15
-- opt.pumwidth = 15
opt.laststatus = 0
opt.cmdheight = 1
opt.statusline = "%<%f   %h%m%r%= %-14.(%l[%L],%c%V%) %P %y"

-- <U+%04B>
-- vim.cmd([[
-- set statusline=%{expand(\"%:p:h\")}\ %y\ \ %h%m%r
--     \%=\ <U+%04B>\ [X:%v/%{&tw}]\ [Y:%l/%L]
-- set titlestring=%t\ -\ Vim
-- ]])
-- vim.cmd([[
-- set statusline=%f\ (%{expand(\"%:p:h\")})\ %y\ \ %h%m%r
--     \\ \ %#Error#%{&ff=='unix'?'':'\ '.&ff.'\ '}%*
--     \\ \ %#Error#%{&fenc==''?'':&fenc=='utf-8'?'':'\ '.&fenc.'\ '}%*
--     \\ \ %#Error#%{&bomb?'\ BOM\ ':''}%*
--     \\ \ %#Error#%{&et?'':'\ NOET\ '}%*
--     \\ \ %#String#%{&paste?'\ PASTE\ ':''}%*
--     \\ \ %#String#%{&fo=~'t'?'\ HARDWRAP\ ':''}%*
--     \\ \ %#Visual#%{&wrap?'\ SOFTWRAP\ ':''}%*
--     \\ \ %#Visual#%{&tw==0?'\ UNLIMITED\ ':''}%*
--     \%=\ <U+%04B>\ [X:%v/%{&tw}]\ [Y:%l/%L]
-- set titlestring=%t\ -\ Vim
-- ]])
-- opt.showtabline = 2
-- opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
-- opt.synmaxcol = 240 -- Max column for syntax highlighting
-- opt.compatible = false
opt.incsearch = true  -- highlight incrementally rather than the whole word word
-- vim.g.netrw_browsex_viewer = os.getenv("BROWSER")
opt.ignorecase = true -- only ignore case if write uppercase letter
opt.smartcase = true  -- only ignore case if write uppercase letter
-- vim.formatoptions +=cro
opt.guicursor = "n:block"
-- "n-v-c-ci:block,i-ve:ver25,r-cr:hor20,o:block,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
-- opt.linebreak = false
-- NOTE: see help tabstop to see options for spaces over tabs
vim.cmd("set shortmess+=A") -- disable swap warnings (I can use vim -r to get into recovery mode)

-- opt.tabstop = 4 -- number of visual spaces per TAB
-- opt.shiftwidth = 4 -- affects block indentation with >> and <<
-- opt.softtabstop = 4 -- affects block indentation with >> and <<
-- opt.autoindent = true -- keep indentation level from previous line
-- opt.smarttab = true

-- opt.expandtab = true -- expand tab to spaces so that tabs are spaces
-- opt.smartindent = true -- Autoindent new lines

opt.title = true

-- better to have, since nvim doesn't have a kill ring
opt.clipboard = "unnamedplus"

opt.undofile = true
local cache = os.getenv("XDG_CACHE_HOME") or os.getenv("HOME") .. "/.cache"
opt.undodir = cache .. "/nvim/undodir/"
opt.backupdir = cache .. "/nvim/backup/"
opt.backup = true
opt.encoding = "utf-8"
opt.scrolloff = 10 -- confuses me when used with scrolling screen with c-y and c-e

-- Spellchecking
-- opt.spell = true
-- opt.spelllang = "en_us"

-- vim.cmd([[
-- if (&term =~ '^st-')
--     " Fix focus events.
--     " TODO Report this upstream? src/os_unix.c already includes a check
--     " for st. Should this work without user intervention? The help page
--     " for "xterm-focus-event" mentions, though, that setting this
--     " manually is sometimes required ...
--     " There was a similar report here: https://github.com/vim/vim/issues/9296
--     let &t_fe = "\<Esc>[?1004h"
--     let &t_fd = "\<Esc>[?1004l"
--     execute "set <FocusGained>=\<Esc>[I"
--     execute "set <FocusLost>=\<Esc>[O"
-- endif
-- ]])

-- opt.autochdir = true

-- Always open splits at the bottom and right
-- opt.splitbelow = true
-- opt.splitright = true

-- TODO look at these from tj
-- opt.showmode = true

-- Ignore compiled files
-- opt.wildignore = "__pycache__"
-- opt.wildignore:append { "*.o", "*~", "*.pyc", "*pycache*" }
-- opt.wildignore:append { "Cargo.lock", "Cargo.Bazel.lock" }

-- Cool floating window popup menu for completion on command line
-- opt.pumblend = 17
-- opt.wildmode = "longest:full"
-- opt.wildoptions = "pum"

opt.showcmd = true
opt.cmdheight = 1    -- Height of the command bar
opt.incsearch = true -- Makes search act like search in modern browsers
-- opt.showmatch      = true -- show matching brackets when text indicator is over them
-- opt.relativenumber = true -- Show line numbers
-- opt.number = true -- But show the actual number for the line we're on
opt.ignorecase = true   -- Ignore case when searching...
opt.smartcase = true    -- ... unless there is a capital letter in the query
opt.hidden = true       -- I like having buffers stay around
opt.equalalways = false -- I don't like my windows changing all the time
opt.updatetime = 1000   -- Make updates happen faster
opt.hlsearch = false
opt.scrolloff = 4       -- Make it so there are always ten lines below my cursor

-- -- these guys make movement slower
-- opt.cursorline = true -- Highlight the current line
-- -- opt.cursorcolumn = true -- Highlight current line
-- local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
-- local set_cursorline = function(event, value, pattern)
-- 	vim.api.nvim_create_autocmd(event, {
-- 		group = group,
-- 		pattern = pattern,
-- 		callback = function()
-- 			vim.opt_local.cursorline = value
-- 			-- vim.opt_local.cursorcolumn = value
-- 		end,
-- 	})
-- end
-- set_cursorline("WinLeave", false)
-- set_cursorline("WinEnter", true)
-- set_cursorline("FileType", false, "TelescopePrompt")

-- opt.colorcolumn = "80"

opt.pumblend = 8
-- opt.signcolumn = "yes"
opt.wildmode = "longest:full"
opt.wildoptions = "pum"

-- Tabs
opt.autoindent = true
opt.cindent = true
opt.wrap = false

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
-- opt.expandtab = true

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

-- opt.foldmethod = "marker"
-- opt.foldlevel = 0
-- opt.modelines = 1

opt.belloff = "all"

opt.inccommand = "split"
opt.shada = { "!", "'1000", "<50", "s10", "h" }

-- opt.mouse = ""

-- Helpful related items:
--   1. :center, :left, :right
--   2. gw{motion} - Put cursor back after formatting motion.
--
-- TODO: w, {v, b, l}
opt.formatoptions = opt.formatoptions
	- "a" -- Auto formatting is BAD.
	- "t" -- Don't auto format my code. I got linters for that.
	+ "c" -- In general, I like it when comments respect textwidth
	+ "q" -- Allow formatting comments w/ gq
	- "o" -- O and o, don't continue comments
	+ "r" -- But do continue when pressing enter.
	+ "n" -- Indent past the formatlistpat, not underneath it.
	+ "j" -- Auto-remove comments if possible.
	- "2" -- I'm not in gradeschool anymore

-- set joinspaces
opt.joinspaces = false -- Two spaces and grade school, we're done

-- set fillchars=eob:~
opt.fillchars = { eob = "~" }

opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }

-- -- better netrw
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25

-- opt.guifont = "Mono:h16" -- text below applies for VimScript
