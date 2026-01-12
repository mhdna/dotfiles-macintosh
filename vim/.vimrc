set bg=light
filetype plugin indent on
syntax on
set laststatus=0

" TODO ultisnips

call plug#begin()
    Plug 'https://github.com/mattn/calendar-vim'
    Plug 'https://github.com/lilydjwg/colorizer'
    " Plug 'https://github.com/morhetz/gruvbox'
    Plug 'https://github.com/mbbill/undotree'
    " Plug 'https://github.com/python-mode/python-mode'
    Plug 'https://github.com/fatih/vim-go'
    "Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'             "| Optional
    Plug 'tpope/vim-projectionist'        
    "Plug 'noahfrederick/vim-composer'     
    "Plug 'SirVer/ultisnips'
    "Plug 'honza/vim-snippets'
    "Plug 'noahfrederick/vim-laravel'
    " Use release branch (recommended)
	"Plug 'neoclide/coc.nvim', {'branch': 'release'}

	" Or build from source code by using npm
	"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
	" Plug 'https://github.com/yaegassy/coc-volar'
	Plug 'https://github.com/vimwiki/vimwiki'
	Plug 'https://github.com/shawncplus/phpcomplete.vim'
call plug#end()

" colorscheme gruvbox
set bg=dark
" set number
" set relativenumber

syntax enable
filetype plugin indent on
set display+=lastline  " @@@ at the end of overlong lines on screen edge

"" set tab width to be 4 spaces
set tabstop=4
" set the size of an 'indent' to be 4 spaces
set shiftwidth=4
" Insert 4 spaces when pressing tab instead of the tab character
set expandtab

" disable lazy redraw
set lazyredraw
" reduce update time for screen updates
set updatetime=100  " Reduce from the default 4000ms
" shorter timeout for key sequences
set timeoutlen=300  " Adjust to a comfortable delay
set ttimeoutlen=100

set scrolloff=2
set showcmd
set sidescroll=1
set sidescrolloff=0
set swapsync=
set timeoutlen=750
set virtualedit=block
set wildmenu

 " On a QWERTZ keyboard, a comma is way easier to reach.
let mapleader=" "
let maplocalleader=" "



" let $FZF_DEFAULT_COMMAND = 'find .'
" nnoremap <leader>f :Files<CR>
" nnoremap <leader>g :Rg<CR>
nnoremap <leader>f :Leaderf file<CR>
nnoremap <leader>g :Leaderf rg<CR>
nnoremap <leader>j :Leaderf function<CR>



let g:vimwiki_list = [{'path':'~/personal/wiki', 'path_html':'~/personal/export/html/'}]


" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsJumpBackwardTrigger="<C-j>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

 " Rather generic settings.

 " " ^A and ^X should ignore minus signs, I almost never need that. (I
 " " think. Let's see how it goes.)
 " " https://utcc.utoronto.ca/~cks/space/blog/unix/VimHandlingDashedNumbers
 " set nrformats+=unsigned

 " " Launch a new terminal window in the current working directory of Vim.
 " " We use setsid here to decouple the new terminal from Vim. Otherwise,
 " " pressing ^Z in Vim to pause it would also pause the new terminal,
 " " which is very irritating.
 " "
 " " Closing the FDs works around VTE bug #204.
 " map <Leader>sx :silent !setsid --fork terminal-wrapper </dev/null >/dev/null 2>&1<CR>

 " " Searching.
 " set hls
 " set incsearch
 " map <F12> :noh<CR>

 " " https://stackoverflow.com/questions/31721993/highlight-the-word-under-cursor-in-gvim#31722469
 " " Have * highlight the word under the cursor but don't jump to the next
 " " occurrence just yet. I've found myself doing "*N" all the time.
 " nmap * :set hls<CR>:<C-u>let @/ = '\<' . expand('<cword>') . '\>'<CR>

 " " No littering.
 " if isdirectory('/tmp/vim-' . $USER) == 0
 "     :silent !install -dm700 /tmp/vim-$USER >/dev/null 2>&1
 " endif
 " set directory=/tmp/vim-$USER//
 " set nobackup
 " set nowritebackup
 " set viminfo=""

 " " Tabs and buffers.
 " "set showtabline=2
 " set tabpagemax=1000
 " " nmap ä gt
 " " nmap ö gT
 " " nmap Ä :+tabm<CR>
 " " nmap Ö :-tabm<CR>
 " " nmap ü :bn<CR>
 " " nmap Ü :bp<CR>

 " " A lot of color columns.
 " fun SetColorColumns(count)
 "     let l:str = ''
 "     let l:at = 1
 "     while (l:at < a:count)
 "         let l:str = l:str . '+' . l:at . ','
 "         let l:at = l:at + 1
 "     endwhile
 "     let l:str = l:str . '+' . a:count

 "     exec 'set colorcolumn=' . l:str
 " endfun
 " " call SetColorColumns(200)

 " " Text width and wrapping.
 " "
 " " Use 72 as default, but don't do hard wrapping unless you're told to
 " " (which is decided based on file types, mostly -- not only those listed
 " " below).
 " set tw=72
 " set fo-=t
 " fun ToggleHardWrapping(...)
 "     if (a:0 || &fo !~ "t")
 "         setl fo+=t
 "     else
 "         setl fo-=t
 "     endif
 " endfun
 " nmap <Leader>w :call ToggleHardWrapping()<CR>
 " autocmd FileType groff,nroff,tex,text setlocal fo+=t
 " nmap <Leader>sw :set wrap!<CR>

 " set nowrap
 " set ai et sta sw=4 sts=4
 " set linebreak

 " fun SetForumWrapping()
 "     set wrap
 "     set tw=0
 "     setl fo-=t
 "     set colorcolumn=
 "     set number
 " endfun
 " nmap <Leader>f :call SetForumWrapping()<CR>

 " map Q gq}

 " " Set default file type to text
 " " https://stackoverflow.com/questions/5487338/vim-set-filetype-txt-for-every-new-file-no-name
 " autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif

 " " Make j and k navigate visual lines.
 " nmap k gk
 " nmap j gj

 " " Ignore ctrl-space because I often hit it on accident.
 " inoremap <C-@> <Space>

 " " Ctrl-L recolors the screen when it gets confused.
 " " http://www.vimbits.com/bits/145
 " noremap <C-l> <C-l>:syntax sync fromstart<CR>
 " inoremap <C-l> <ESC><C-l>:syntax sync fromstart<CR>a

 " " Shortcuts for creating markdown "title" lines and others.
 " map <Leader>h1 <ESC>yyp:keeppatterns s/./=/g<CR>o<CR>
 " map <Leader>h2 <ESC>yyp:keeppatterns s/./-/g<CR>o<CR>
 " map <Leader>sep 36i* <ESC>x

 " " Preview file rendered as markdown.
 " nmap <Leader>md :w !mdview -b<CR>

 " " Invisible characters.
 " set nolist
 " set listchars=tab:\|-,eol:$,precedes:<,extends:>,trail:#,nbsp:%
 " map <F11> :set list!<CR>

 " " Linting.
 " map <Leader>st :%s/[[:space:]]\+$//gc<CR>
 " map <Leader>si :%s/[^[:space:]]\zs[[:space:]]\{2,\}\ze[^[:space:]]/ /gc<CR>
 " map <Leader>sa /[^\x00-\x7F]<CR>

 " " Format columns in visual mode.
 " vnoremap <Leader>c :!sed 's/^/-/' \| column -t \| sed 's/^-//'<CR>
 " vnoremap <Leader>C :!sed 's/^/-/' \| column -t \| sed 's/^-//'<CR>gv=

 " " Alt-right/left to navigate forward/backward in the tags stack.
 " map <ESC>h <C-T>
 " map <ESC>l <C-]>

 " " Folding.
 " map <ESC>j zo
 " map <ESC>k zc
 " map <ESC>J zO
 " map <ESC>K zC
 " set foldcolumn=0
 " set foldmethod=marker
 " set foldlevel=500

" X11 clipboard.
" Closing the FDs works around VTE bug #204.
fun X11Copy()
    silent %w !setsid xclip -selection clipboard >/dev/null 2>&1
endfun

fun X11CopyRegister(reg)
    let l:ignore = system('setsid xclip -selection clipboard >/dev/null 2>&1', getreg(a:reg))
endfun

fun X11PasteClipboard()
    r !xclip -selection clipboard -o
endfun

fun X11PastePrimary()
    r !xclip -o
endfun

nmap <Leader>c :call X11Copy()<CR>
vmap <Leader>c "xy:call X11CopyRegister('x')<CR>
nmap <Leader>p :call X11PasteClipboard()<CR>
nmap <Leader>P :call X11PastePrimary()<CR>
set pastetoggle=<F5>
set mouse=

""  " Terminal fixups.
" set background=dark
""  hi clear
""  if (&t_Co == 256)
""      colo herald2
""  else
""      hi  ColorColumn  ctermbg=4
""      hi  TabLineSel   ctermbg=4
""      hi  PmenuSel     ctermfg=1 ctermbg=0
""  endif

 " if (&term =~ '^linux')
 "     map <ESC>[31~ <S-F5>
 " endif

 " if (&term =~ '^xterm' || &term =~ '^rxvt' || &term =~ '^st-')
 "     set title
 " endif

 " if (&term =~ '^st-')
 "     " Fix focus events.
 "     " TODO Report this upstream? src/os_unix.c already includes a check
 "     " for st. Should this work without user intervention? The help page
 "     " for "xterm-focus-event" mentions, though, that setting this
 "     " manually is sometimes required ...
 "     " There was a similar report here: https://github.com/vim/vim/issues/9296
 "     let &t_fe = "\<Esc>[?1004h"
 "     let &t_fd = "\<Esc>[?1004l"
 "     execute "set <FocusGained>=\<Esc>[I"
 "     execute "set <FocusLost>=\<Esc>[O"
 " endif

 " " Status line.
 " set laststatus=2
 " set statusline=%f\ (%{expand(\"%:p:h\")})\ %y\ \ %h%m%r
 "     \\ \ %#Error#%{&ff=='unix'?'':'\ '.&ff.'\ '}%*
 "     \\ \ %#Error#%{&fenc==''?'':&fenc=='utf-8'?'':'\ '.&fenc.'\ '}%*
 "     \\ \ %#Error#%{&bomb?'\ BOM\ ':''}%*
 "     \\ \ %#Error#%{&et?'':'\ NOET\ '}%*
 "     \\ \ %#String#%{&paste?'\ PASTE\ ':''}%*
 "     \\ \ %#String#%{&fo=~'t'?'\ HARDWRAP\ ':''}%*
 "     \\ \ %#Visual#%{&wrap?'\ SOFTWRAP\ ':''}%*
 "     \\ \ %#Visual#%{&tw==0?'\ UNLIMITED\ ':''}%*
 "     \%=\ <U+%04B>\ [X:%3v/%3{&tw}]\ [Y:%5l/%5L]
 " set titlestring=%t\ -\ Vim

 " " Printing from Vim is complicated due to UTF-8. The author of the PS
 " " driver explained it here:
 " " http://vim.1045645.n5.nabble.com/Printing-with-utf-8-characters-on-Windows-td1193441.html
 " " So, just use plain old "lp" as a workaround.
 " fun Hardcopy()
 "     " CUPS documentation says about "-o page-*":
 "     " The value argument is the margin in points; each point is 1/72
 "     " inch or 0.35mm.
 "     " http://www.cups.org/documentation.php/doc-1.7/options.html
 "     " I want a margin of about 1.8cm.
 "     exe "!lp -o media=A4 -o page-left=50 -o page-right=50"
 "         \" -o page-top=50 -o page-bottom=50 -o prettyprint"
 "         \(&pdev != "" ? " -d " . &pdev : "") . " " . expand("%")
 " endfun
 " command Hardcopy :call Hardcopy()

 " " Integration with explain.
 " fun DoExplainFile(explargs, yankundo)
 "     let l:prev = getpos(".")
 "     %s/<<<explain\n\(\_.\{-}\n\)>>>\n/
 "         \\=system("explain ".a:explargs, submatch(1))/g

 "     if a:yankundo
 "         call X11Copy()
 "         u
 "     endif

 "     call setpos(".", l:prev)
 "     noh
 " endfun
 " nmap <Leader>eyn :call DoExplainFile("", 1)<CR>
 " nmap <Leader>ehn :call DoExplainFile("", 0)<CR>
 " nmap <Leader>eyu :call DoExplainFile("-u", 1)<CR>
 " nmap <Leader>ehu :call DoExplainFile("-u", 0)<CR>

 " " Integration with gitary: Spawn terminal in gitary blob dir.
 " fun GitaryBlobDirTerminal()
 "     let l:blobdir = systemlist('gitary --blob ' . expand('%:p:S'))[0]
 "     let l:cmd = 'mkdir -p ' . l:blobdir . ' && ' .
 "       \ 'cd ' . l:blobdir . ' && ' .
 "       \ 'terminal-wrapper &'
 "     silent exec '!' . l:cmd
 " endfun
 " map <Leader>sg :call GitaryBlobDirTerminal()<CR>

 " " Integration with groff.
 " nmap <Leader>rggu :w \| !~/work/troff/lib/plaintext/render "%"<CR>
 " nmap <Leader>rgga :w \| !~/work/troff/lib/plaintext/render "%" ascii<CR>

 " " Settings for the plugin bundled with fzf
 " nmap <Leader>gf :FZF<CR>

 " " Settings for calendar plugin.
 " " https://github.com/mattn/calendar-vim
 " let g:calendar_monday=1
 " let g:calendar_options='colorcolumn=0'
 " let g:calendar_weeknm=3
 " nmap <S-F3> :Calendar<CR><C-W><C-W>

 " " Settings for NERDTree.
 " " https://github.com/scrooloose/nerdtree
 " let NERDTreeShowHidden=1
 " nmap <S-F2> :NERDTreeToggle<CR>

 " " Quickly create QR codes from text.
 " nmap <Leader>qr :%!qr --ascii<CR>

 " " Settings for editorconfig.
 " " Clobbers colorcolumn by default. I don't want that, just set the damn
 " " line length. Same goes for formatoptions.
 " " (max_line_length is not an official feature:
 " " https://github.com/editorconfig/editorconfig/issues/89)
 " let g:EditorConfig_max_line_indicator = 'go-away'
 " let g:EditorConfig_preserve_formatoptions = 1

 " au BufRead,BufNewFile jenny-posting.eml call SetForumWrapping()

 " " A bit like good old T.EXE, which I've been using a lot lately:
 " fun TConfirmQuit()
 "     if &modified
 "         echo "Throw away changes? (y/n) "
 "         let l:c = nr2char(getchar())
 "         if l:c == 'y'
 "             quit!
 "         endif
 "         redraw!
 "     else
 "         quit
 "     endif
 " endfun
 " nmap <F2> :w<CR>
 " nmap <F3> :call TConfirmQuit()<CR>
 " nmap <F4> :wq<CR>

 " " BundleWrap
 " fun BWAlternate()
 "     let l:fname = expand('%')
 "     if l:fname[-len('items.py'):] == 'items.py'
 "         let l:oname = l:fname[:-len('items.py') - 1] . 'metadata.py'
 "         exec 'tabe ' . l:oname
 "     elseif l:fname[-len('metadata.py'):] == 'metadata.py'
 "         let l:oname = l:fname[:-len('metadata.py') - 1] . 'items.py'
 "         exec 'tabe ' . l:oname
 "     endif
 " endfun
 " nmap <Leader>bwa :call BWAlternate()<CR>

 " " Maybe overwrite or append settings based on local host.
 " if filereadable(glob("~/.vimrc.local"))
 "     source ~/.vimrc.local
 " endif

 " set guifont=Monospace:h18 " text below applies for VimScript
 "
"
"
"
" GUI
" set guifont=Mono\ 13
" nnoremap ZZ :call QuitPrompt()<cr>
" 
" fun! QuitPrompt()
"    if has("gui_running") && tabpagenr("$") == 1 && winnr("$") == 1 let choice = confirm("Close?", "&yes\n&no", 1)
"       if choice == 1 | wq | endif
"    else | wq | endif
" endfun
" 
" set toolbariconsize=large
"


" =========================== Coc settings =========================== "
" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config
"inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1) :
"      \ CheckBackspace() ? "\<Tab>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"
"" Make <CR> to accept selected completion item or notify coc.nvim to format
"" <C-g>u breaks current undo, please make your own choice
"inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"function! CheckBackspace() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif
"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
"nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
"nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
"
"" GoTo code navigation
"nmap <silent><nowait> gd <Plug>(coc-definition)
"nmap <silent><nowait> gy <Plug>(coc-type-definition)
"nmap <silent><nowait> gi <Plug>(coc-implementation)
"nmap <silent><nowait> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window
"nnoremap <silent> K :call ShowDocumentation()<CR>
"
"function! ShowDocumentation()
"  if CocAction('hasProvider', 'hover')
"    call CocActionAsync('doHover')
"  else
"    call feedkeys('K', 'in')
"  endif
"endfunction
"
"" Highlight the symbol and its references when holding the cursor
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Symbol renaming
"nmap <leader>rn <Plug>(coc-rename)
"
"" Formatting selected code
"xmap <leader>=  <Plug>(coc-format-selected)
"nmap <leader>=  <Plug>(coc-format-selected)
"
"augroup mygroup
"  autocmd!
"  " Setup formatexpr specified filetype(s)
"  autocmd FileType typescript,json,vue,go,python setl formatexpr=CocAction('formatSelected')
"augroup end
"
"" Applying code actions to the selected code block
"" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"" Remap keys for applying code actions at the cursor position
"nmap <leader>ac  <Plug>(coc-codeaction-cursor)
"" Remap keys for apply code actions affect whole buffer
"nmap <leader>as  <Plug>(coc-codeaction-source)
"" Apply the most preferred quickfix action to fix diagnostic on the current line
"nmap <leader>qf  <Plug>(coc-fix-current)
"
"" Remap keys for applying refactor code actions
"nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
"xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
"nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
"
"" Run the Code Lens action on the current line
"nmap <leader>cl  <Plug>(coc-codelens-action)
"
"" Map function and class text objects
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)
"
"" Remap <C-f> and <C-b> to scroll float windows/popups
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif
"
"" Use CTRL-S for selections ranges
"" Requires 'textDocument/selectionRange' support of language server
"nmap <silent> <C-s> <Plug>(coc-range-select)
"xmap <silent> <C-s> <Plug>(coc-range-select)
"
"" Add `:Format` command to format current buffer
"command! -nargs=0 Format :call CocActionAsync('format')
"
"" Add `:Fold` command to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"" Add `:OR` command for organize imports of the current buffer
"command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
"
"" Add (Neo)Vim's native statusline support
"" NOTE: Please see `:h coc-status` for integrations with external plugins that
"" provide custom statusline: lightline.vim, vim-airline
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
"" Mappings for CoCList
"" Show all diagnostics
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
"
"
"" ==================== Undotree =======================
"nnoremap <F5> :UndotreeToggle<CR>
"if has("persistent_undo")
"   let target_path = expand('~/.undodir')
"
"    " create the directory and any parent directories
"    " if the location does not exist.
"    if !isdirectory(target_path)
"        call mkdir(target_path, "p", 0700)
"    endif
"
"    let &undodir=target_path
"    set undofile
"endif
