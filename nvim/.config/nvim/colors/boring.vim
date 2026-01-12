set notermguicolors

" Inspired by and based on Berk D. Demir's `noclown`:
" https://github.com/bdd/.vim/blob/09b4dbef06612c52c9c160773645bea82c0f490d/colors/noclown.vim

hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "boring"

" Terminals that don't support italics resort to rendering them as standout.
" For comments and other things we italicize, this can become annoying very
" quickly.  We are going to ignore 'italic' attribute if the terminal doesn't
" know about it.
let g:boring_has_italics = 1
if (has('gui_running') || has('unix') && system('tput sitm') == "\e[3m")
  let g:boring_has_italics = 1
endif

let s:palette = {
      \ 'bg'   :        [ "None", "None" ],
      \ 'fg'   :        [ "None", "None" ],
      \ 'dull' :        [ "None", "None" ],
      \ 'dark' :        [ "None", "None" ],
      \ 'deep' :        [ "None", "None" ],
      \ 'accent' :      [ "None", "None" ],
      \ 'darkred' :     [ "None", "None" ],
      \ 'darkyellow' :  [ "None", "None" ],
      \ 'darkblue' :    [ "None", "None" ],
      \ 'darkgreen' :   [ "None", "None" ],
      \ 'lightgreen' :  [ "None", "None" ],
      \ 'lightyellow' : [ "None", "None" ],
      \ 'lightred' :    [ "None", "None" ],
      \ }
" dark*/light* are cheating with going below 5f / above df

function! s:Clear(group)
  execute 'highlight! clear ' . a:group
  execute 'highlight ' . a:group . ' NONE'
endfunction

function! s:Define(group, fg, bg, style)
  call s:Clear(a:group)

  let [l:ctermfg, l:guifg] = s:palette[a:fg]
  let [l:ctermbg, l:guibg] = s:palette[a:bg]

  let l:style = g:boring_has_italics || a:style != 'italic' ? a:style : 'NONE'

  let l:hi_expr = 'highlight ' . a:group
  let l:hi_expr .= ' cterm=' . l:style
  let l:hi_expr .= ' ctermfg=' . l:ctermfg
  let l:hi_expr .= ' ctermbg=' . l:ctermbg
  let l:hi_expr .= ' gui=' . l:style
  let l:hi_expr .= ' guifg=' . l:guifg
  let l:hi_expr .= ' guibg=' . l:guibg

  execute l:hi_expr
endfunction

function! s:Link(from, to)
  call s:Clear(a:from)
  execute 'highlight link ' . a:from . ' ' . a:to
endfunction

" call s:Define('Normal',          'fg',          'bg',   'NONE')
" call s:Define('Constant',        'dull',        'bg',   'NONE')
" call s:Define('String',          'dull',        'bg',   'NONE')
 call s:Define('Comment',         'dark',        'bg',   'NONE')
" call s:Define('SpecialKey',      'deep',        'bg',   'NONE')
" call s:Define('Todo',            'accent',      'bg',   'bold')
" call s:Define('Search',          'fg',          'deep', 'NONE')
" call s:Define('Folded',          'dark',        'bg',   'inverse')
" call s:Define('Title',           'fg',          'bg',   'bold')
" call s:Define('Underlined',      'fg',          'bg',   'underline')
" call s:Define('Pmenu',           'fg',          'bg',   'inverse')
" call s:Define('PmenuSel',        'fg',          'bg',   'bold')
" call s:Define('MatchParen',      'fg',          'deep', 'bold')
" call s:Define('EndOfBuffer',     'deep',        'bg',   'bold')
" call s:Define('SpecialChar',     'dull',        'bg',   'italic')
" call s:Define('DiagnosticError', 'darkred',     'bg',   'NONE')
" call s:Define('DiagnosticWarn',  'darkyellow',  'bg',   'NONE')
" call s:Define('DiagnosticInfo',  'darkblue',    'bg',   'NONE')
" call s:Define('DiagnosticHint',  'darkgreen',   'bg',   'NONE')
" call s:Define('diffAdded',       'lightgreen',  'bg',   'NONE')
" call s:Define('diffRemoved',     'lightred',    'bg',   'NONE')
" call s:Define('diffChanged',     'lightyellow', 'bg',   'NONE')
" call s:Define('diffLine',        'dark',        'bg',   'NONE')
" call s:Define('diffNewFile',     'dark',        'bg',   'NONE')
" call s:Define('diffOldFile',     'dark',        'bg',   'NONE')
" call s:Define('diffIndexLine',   'dark',        'bg',   'NONE')
" call s:Define('diffFile',        'dark',        'bg',   'NONE')

call s:Clear('Normal')
call s:Clear('NormalFloat')
call s:Clear('Constant')
" call s:Clear('String')
highlight Comment ctermfg=darkgray guifg=darkgray
highlight String gui=italic term=italic cterm=italic
highlight Visual guifg=NONE ctermfg=NONE ctermbg=NONE guibg=NONE gui=reverse cterm=reverse term=reverse
highlight MatchParen guifg=NONE ctermfg=NONE ctermbg=NONE guibg=NONE gui=underline cterm=underline term=reverse
call s:Clear('SpecialKey')
call s:Clear('Todo')
call s:Clear('Search')
call s:Clear('Folded')
call s:Clear('Title')
" call s:Clear('Underlined')
" call s:Clear('Pmenu')
call s:Define('Pmenu',           'fg',          'bg',   'inverse')
" call s:Clear('PmenuSel')
call s:Define('PmenuSel',        'bg',          'fg',   'underline,bold')
" call s:Clear('MatchParen')
call s:Clear('EndOfBuffer')
call s:Clear('SpecialChar')
call s:Clear('DiagnosticError')
call s:Clear('DiagnosticWarn')
call s:Clear('DiagnosticInfo')
call s:Clear('DiagnosticHint')
call s:Clear('diffAdded')
call s:Clear('diffRemoved')
call s:Clear('diffChanged')
call s:Clear('diffLine')
call s:Clear('diffNewFile')
call s:Clear('diffOldFile')
call s:Clear('diffIndexLine')
call s:Clear('diffFile')


call s:Clear('Identifier')
call s:Clear('Special')
call s:Clear('Statement')
call s:Clear('Type')
call s:Clear('WarningMsg')
call s:Clear('Wildmenu')
call s:Clear('Directory')
call s:Clear('LineNr')
call s:Clear('SignColumn')

call s:Link('IncSearch', 'Visual')
call s:Link('PreProc', 'Normal')
call s:Link('NonText', 'SpecialKey')
call s:Link('Error', 'Search')
call s:Link('ErrorMsg', 'Search')
call s:Link('FoldColumn', 'Folded')

"highlight Keyword gui=bold cterm=bold
"highlight Function gui=bold cterm=bold
"highlight Type gui=bold cterm=bold
