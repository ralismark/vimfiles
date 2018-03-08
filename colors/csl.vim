hi clear

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="csl"

" UI Styling {{{1 --------------------------------------------------------------

" General text style
hi Normal ctermfg=black ctermbg=white
hi NonText ctermfg=grey
hi SpecialKey ctermfg=darkgrey cterm=italic
hi Visual ctermfg=white ctermbg=darkred
hi link VisualNOS Visual

" Status/Tab line
hi StatusLine ctermfg=white ctermbg=darkgrey cterm=NONE
hi StatusLineNC ctermfg=darkgrey ctermbg=grey cterm=NONE
hi TabLine ctermfg=darkgrey ctermbg=grey
hi TabLineFill ctermfg=white
hi TabLineSel ctermfg=white ctermbg=darkgrey

" Ex Commmand Stuff
hi WarningMsg ctermfg=black ctermbg=yellow
hi ErrorMsg ctermfg=white ctermbg=red
hi ModeMsg ctermfg=white ctermbg=darkblue
" hi Question ctermfg=

" hi WarningMsg           ctermfg=0       ctermbg=11
" hi ErrorMsg             ctermfg=15      ctermbg=1
" hi ModeMsg              ctermfg=2       ctermbg=bg
" hi Question             ctermfg=2       ctermbg=bg
" hi WildMenu             ctermfg=0       ctermbg=14
