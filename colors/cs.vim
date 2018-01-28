hi clear

if exists("syntax_on")
	syntax reset
endif
let g:colors_name="cs"

" UI Styles {{{1 -------------------------------------------------------------

" General text style
hi Normal               ctermfg=7       ctermbg=0
hi NonText              ctermfg=8       ctermbg=bg
hi SpecialKey           ctermfg=8       ctermbg=bg
hi Visual               ctermfg=15      ctermbg=1
hi link VisualNOS       Visual

" Status/Tab line
hi StatusLine           ctermfg=15      ctermbg=8
hi StatusLineNC         ctermfg=7       ctermbg=8
hi TabLine              ctermfg=15      ctermbg=bg
hi TabLineFill          ctermfg=7       ctermbg=bg
hi TabLineSel           ctermfg=0       ctermbg=1

" Below the statusline / ex command region
hi WarningMsg           ctermfg=0       ctermbg=11
hi ErrorMsg             ctermfg=15      ctermbg=1
hi ModeMsg              ctermfg=2       ctermbg=bg
hi Question             ctermfg=2       ctermbg=bg
hi WildMenu             ctermfg=0       ctermbg=14

" Spell
hi SpellBad             ctermfg=4       ctermbg=bg  cterm=underline
hi SpellLocal           ctermfg=4       ctermbg=bg  cterm=underline
hi SpellCap             ctermfg=6       ctermbg=bg  cterm=underline
hi SpellRare            ctermfg=6       ctermbg=bg  cterm=underline

" Search
hi Search               ctermfg=0       ctermbg=6
hi IncSearch            ctermfg=0       ctermbg=2

" Gutter
hi LineNr               ctermfg=8       ctermbg=bg
hi CursorLineNr         ctermfg=6       ctermbg=bg
hi FoldColumn           ctermfg=4       ctermbg=0
hi SignColumn           ctermfg=7       ctermbg=0

" Lines
hi ColorColumn          ctermfg=0       ctermbg=8
hi CursorColumn                         ctermbg=8
hi CursorLine                           ctermbg=bg
hi Folded               ctermfg=8       ctermbg=bg
hi VertSplit            ctermfg=8       ctermbg=8

" Diff
hi DiffAdd              ctermfg=2       ctermbg=bg
hi DiffChange           ctermfg=11      ctermbg=bg
hi DiffDelete           ctermfg=1       ctermbg=bg
hi DiffText             ctermfg=3       ctermbg=bg

" Popup Menu
hi Pmenu                ctermfg=15      ctermbg=8
hi PmenuSel             ctermfg=0       ctermbg=7
hi PmenuSbar            ctermfg=6       ctermbg=0

" Misc
hi MatchParen           ctermfg=0       ctermbg=6
hi Directory            ctermfg=4       ctermbg=bg

" Syntax {{{1 ----------------------------------------------------------------

hi Comment              ctermfg=8

hi Constant             ctermfg=5
hi String               ctermfg=2
hi link Character       String
hi Number               ctermfg=9
hi Boolean              ctermfg=5
hi link Float           Number

hi Identifier           ctermfg=6
hi Function             ctermfg=2

hi Statement            ctermfg=4

hi PreProc              ctermfg=2
hi Include              ctermfg=6
hi Define               ctermfg=4
hi link Macro           Define
hi link PreCondit       PreProc

hi Type                 ctermfg=9
hi StorageClass         ctermfg=6
hi link Structure       StorageClass
hi link Typedef         StorageClass

hi Error                ctermfg=7       ctermbg=4

hi Todo                 ctermfg=6       ctermbg=bg

