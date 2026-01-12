" Vim color file
" File:         termpot.vim
" Maintainer:   Peter Hofmann
" Version:      3
" Last Change:  2021-05-13
" Contributors: Anyone who contributed to the original "inkpot" scheme.

hi clear
" if exists("syntax_on")
"     syntax reset
" endif

let g:colors_name = "termpot"

if &background == "dark"
    hi  Normal          cterm=NONE  ctermfg=229  ctermbg=NONE "232
    hi  IncSearch       cterm=BOLD  ctermfg=232  ctermbg=226
    hi  Search          cterm=NONE  ctermfg=232  ctermbg=33
    hi  ErrorMsg        cterm=BOLD  ctermfg=231  ctermbg=196
    hi  WarningMsg      cterm=BOLD  ctermfg=231  ctermbg=202
    hi  ModeMsg         cterm=BOLD  ctermfg=63
    hi  MoreMsg         cterm=BOLD  ctermfg=63
    hi  Question        cterm=BOLD  ctermfg=214
    hi  StatusLine      cterm=BOLD  ctermfg=244  ctermbg=235
    hi  StatusLineNC    cterm=NONE  ctermfg=244  ctermbg=235
    hi  VertSplit       cterm=NONE  ctermfg=235  ctermbg=235
    hi  WildMenu        cterm=BOLD  ctermfg=214  ctermbg=232

    hi  DiffText        cterm=NONE  ctermfg=229  ctermbg=34
    hi  DiffChange      cterm=NONE  ctermfg=229  ctermbg=27
    hi  DiffDelete      cterm=NONE  ctermfg=229  ctermbg=124
    hi  DiffAdd         cterm=NONE  ctermfg=229  ctermbg=34

    hi  Folded          cterm=BOLD  ctermfg=130  ctermbg=233
    hi  FoldColumn      cterm=NONE  ctermfg=61   ctermbg=232

    hi  Directory       cterm=NONE  ctermfg=47   ctermbg=NONE
    hi  LineNr          cterm=BOLD  ctermfg=241  ctermbg=233
    hi  NonText         cterm=NONE  ctermfg=52   ctermbg=16
    hi  SpecialKey      cterm=NONE  ctermfg=52   ctermbg=NONE
    hi  Title           cterm=BOLD  ctermfg=130  ctermbg=232
    hi  Visual          cterm=NONE  ctermfg=232  ctermbg=215

    hi  TabLine         cterm=NONE  ctermfg=241  ctermbg=233
    hi  TabLineSel      cterm=BOLD  ctermfg=255  ctermbg=235
    hi  TabLineFill     cterm=NONE  ctermfg=229  ctermbg=245

    hi  Comment         cterm=NONE  ctermfg=130  ctermbg=NONE
    hi  Constant        cterm=NONE  ctermfg=215  ctermbg=NONE
    hi  String          cterm=NONE  ctermfg=215  ctermbg=237
    hi  Error           cterm=NONE  ctermfg=231  ctermbg=196
    hi  Identifier      cterm=NONE  ctermfg=207  ctermbg=NONE
    hi  Ignore          cterm=NONE  ctermfg=61   ctermbg=NONE
    hi  Number          cterm=NONE  ctermfg=70   ctermbg=NONE
    hi  PreProc         cterm=NONE  ctermfg=40   ctermbg=NONE
    hi  Special         cterm=NONE  ctermfg=63   ctermbg=NONE
    hi  Statement       cterm=NONE  ctermfg=37   ctermbg=NONE
    hi  Todo            cterm=BOLD  ctermfg=237  ctermbg=63
    hi  Type            cterm=NONE  ctermfg=207  ctermbg=NONE
    hi  Underlined      cterm=BOLD  ctermfg=229  ctermbg=NONE
    hi  TaglistTagName  cterm=BOLD  ctermfg=37   ctermbg=NONE
    hi  MatchParen      cterm=NONE  ctermfg=NONE    ctermbg=NONE
	" mhd: ctermbg was 37
    hi  Pmenu           cterm=NONE  ctermfg=229    ctermbg=234 " 208
    hi  PmenuSel        cterm=BOLD  ctermfg=232  ctermbg=130 "232
    hi  PmenuSbar       cterm=NONE  ctermbg=240
    hi  PmenuThumb      cterm=NONE  ctermbg=255

    hi  CursorLineNr    ctermfg=214 ctermbg=233 cterm=NONE
    " hi  CursorLine      cterm=NONE
    hi  CursorLine      ctermbg=235 cterm=NONE
    hi  CursorColumn    ctermbg=235

    hi  ColorColumn     ctermbg=233
else
    " Content
    hi  Normal       ctermfg=16   ctermbg=231
    hi  Statement    ctermfg=130  cterm=bold
    hi  Identifier   ctermfg=19   cterm=bold
    hi  Type         ctermfg=70   cterm=bold
    hi  String       ctermbg=195
    hi  Comment      ctermfg=141
    hi  Special      cterm=bold
    hi  SpecialChar  ctermfg=13   ctermbg=195  cterm=bold
    hi  PreProc      cterm=bold
    hi  SpecialKey   ctermfg=33
    hi  NonText      ctermfg=33
    hi  Todo         ctermbg=226
    hi  Ignore       ctermfg=226  ctermbg=0    cterm=bold

    " User interface
    hi  ModeMsg       ctermfg=16   cterm=bold
    hi  WarningMsg    ctermfg=15   ctermbg=178      cterm=bold
    hi  ErrorMsg      ctermfg=15   ctermbg=1        cterm=bold
    hi  Visual        ctermbg=226
    hi  StatusLine    ctermfg=15   ctermbg=17       cterm=bold
    hi  StatusLineNC  ctermfg=0    ctermbg=250      cterm=none
    hi  VertSplit     ctermfg=250  ctermbg=250      cterm=none
    hi  LineNr        ctermfg=0    ctermbg=253
    hi  TabLine       ctermbg=250  cterm=none
    hi  TabLineFill   ctermbg=245  cterm=underline
    hi  TabLineSel    ctermbg=255
    hi  Folded        ctermfg=0    ctermbg=255
    hi  FoldColumn    ctermfg=0    ctermbg=255
    hi  IncSearch     ctermfg=16   ctermbg=214      cterm=none
    hi  Search        ctermfg=16   ctermbg=190      cterm=bold
    hi  WildMenu      ctermbg=226
    hi  PmenuSel      ctermbg=226
    hi  ColorColumn   ctermbg=230

    " diff filetype
    hi  diffRemoved  ctermfg=160  cterm=bold
    hi  diffAdded    ctermfg=40   cterm=bold

    " vimdiff
    hi  DiffAdd     ctermfg=16  ctermbg=46   cterm=bold
    hi  DiffChange  ctermfg=16  ctermbg=87
    hi  DiffDelete  ctermfg=16  ctermbg=1    cterm=bold
    hi  DiffText    ctermfg=16  ctermbg=190  cterm=bold

    " Mail
    hi  mailQuoted1  ctermfg=1
    hi  mailQuoted2  ctermfg=33
    hi  mailSubject  ctermfg=16  ctermbg=229  cterm=bold
    hi  mailHeader   ctermfg=16  cterm=bold

    " Help
    hi  helpExample  ctermfg=166  cterm=bold
end
