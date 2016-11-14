" Vim color file
" Maintainer:   Ruda Moura <ruda.moura@gmail.com>
" Last Change:	$Date: 2005/11/12 15:40:06 $

set background=dark
highlight clear
if exists("syntax on")
  syntax reset
endif

let g:colors_name = "mydarkzen"

highlight Normal     term=none ctermfg=white       cterm=none guifg=white       gui=none guibg=black
highlight Comment    term=none ctermfg=cyan        cterm=none guifg=cyan        gui=none
highlight Constant   term=none ctermfg=darkgreen   cterm=none guifg=forestgreen gui=none
highlight pythonBuiltin    term=none ctermfg=darkgreen   cterm=none guifg=forestgreen gui=none
highlight Special    term=none ctermfg=magenta     cterm=bold guifg=magenta     gui=bold
highlight Identifier term=none ctermfg=white       cterm=none guifg=white       gui=none
highlight Statement  term=bold ctermfg=yellow      cterm=bold guifg=yellow      gui=bold
highlight Operator   term=bold ctermfg=white       cterm=bold guifg=white       gui=bold
highlight PreProc    term=bold ctermfg=magenta     cterm=none guifg=magenta     gui=none
highlight Type       term=bold ctermfg=darkgreen   cterm=none guifg=magenta     gui=bold
highlight String     term=none ctermfg=darkred     cterm=none guifg=red         gui=none
highlight Number     term=none ctermfg=darkred     cterm=none guifg=red         gui=none
highlight SpellBad   term=none ctermbg=darkmagenta cterm=none gui=undercurl     guibg=darkmagenta
" vim:ts=2:sw=2:et

