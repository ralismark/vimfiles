hi clear

if exists("syntax_on")
	syntax reset
endif
let g:colors_name="cs-dark"

" UI Styles {{{1 -------------------------------------------------------------

" General text style
hi Normal               ctermfg=0       ctermbg=7
hi NonText              ctermfg=1       ctermbg=bg
hi SpecialKey           ctermfg=3       ctermbg=bg
hi Visual               ctermfg=7       ctermbg=1
hi link VisualNOS       Visual

" Status/Tab line
hi StatusLine           ctermfg=15      ctermbg=0
hi StatusLineNC         ctermfg=8       ctermbg=0
hi TabLine              ctermfg=8       ctermbg=bg
hi TabLineFill          ctermfg=0       ctermbg=bg
hi TabLineSel           ctermfg=0       ctermbg=1

" Below the statusline / ex command region
hi WarningMsg           ctermfg=0       ctermbg=6
hi ErrorMsg             ctermfg=7       ctermbg=4
hi ModeMsg              ctermfg=5       ctermbg=bg
hi Question             ctermfg=5       ctermbg=bg
hi WildMenu             ctermfg=0       ctermbg=14

" Spell
hi SpellBad             ctermfg=4       ctermbg=bg
hi SpellCap             ctermfg=6       ctermbg=bg
hi link SpellLocal      SpellCap
hi link SpellRare       SpellCap

" Search
hi Search               ctermfg=0       ctermbg=6
hi IncSearch            ctermfg=0       ctermbg=2

" Gutter
hi LineNr               ctermfg=8       ctermbg=bg
hi CursorLineNr         ctermfg=6       ctermbg=bg
hi FoldColumn           ctermfg=1       ctermbg=0
hi SignColumn           ctermfg=3       ctermbg=bg

" Lines
hi ColorColumn                          ctermbg=15
hi CursorColumn                         ctermbg=3
hi CursorLine                           ctermbg=15
hi Folded               ctermfg=8       ctermbg=bg
hi VertSplit            ctermfg=8       ctermbg=8

" Diff
hi DiffAdd              ctermfg=2       ctermbg=bg
hi DiffChange           ctermfg=6       ctermbg=bg
hi DiffDelete           ctermfg=4       ctermbg=bg
hi DiffText             ctermfg=6       ctermbg=bg

" Popup Menu
hi Pmenu                ctermfg=15      ctermbg=8
hi PmenuSel             ctermfg=15      ctermbg=3
hi PmenuSbar            ctermfg=6       ctermbg=0

" Misc
hi MatchParen           ctermfg=0       ctermbg=6
hi Directory            ctermfg=4       ctermbg=bg
" Syntax {{{1 ----------------------------------------------------------------

hi Comment              ctermfg=3 " comment

hi Constant             ctermfg=1
hi String               ctermfg=6
hi link Character       String
hi Number               ctermfg=5
hi Boolean              ctermfg=5
hi link Float           Number

hi Identifier           ctermfg=4
hi Function             ctermfg=5

hi Statement            ctermfg=4

hi PreProc              ctermfg=6
hi Include              ctermfg=2
hi Define               ctermfg=4
hi link Macro           Define
hi link PreCondit       PreProc

hi Type                 ctermfg=11
hi StorageClass         ctermfg=6
hi link Structure       StorageClass
hi link Typedef         StorageClass

hi Error                ctermfg=7       ctermbg=4

hi Todo                 ctermfg=3       ctermbg=bg
