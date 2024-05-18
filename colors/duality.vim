" vim:set fdm=marker:
"        ██                    ██ ██   ██
"       ░██                   ░██░░   ░██    ██   ██
"       ░██ ██   ██  ██████   ░██ ██ ██████ ░░██ ██
"    ██████░██  ░██ ░░░░░░██  ░██░██░░░██░   ░░███
"   ██░░░██░██  ░██  ███████  ░██░██  ░██     ░██
"  ░██  ░██░██  ░██ ██░░░░██  ░██░██  ░██     ██
"  ░░██████░░██████░░████████ ███░██  ░░██   ██
"   ░░░░░░  ░░░░░░  ░░░░░░░░ ░░░ ░░    ░░   ░░

hi clear

if exists("syntax_on")
	syntax reset
endif

let g:colors_name = "duality"

"  █▓▒░ GUI colors {{{1

" General Text Styling {{{2
hi Normal       ctermfg=white
hi Conceal      ctermfg=NONE            ctermbg=black
hi NonText      ctermfg=darkgrey
hi SpecialKey   ctermfg=darkblue
hi Visual       ctermfg=white           ctermbg=red
hi link VisualNOS Visual
hi MatchParen   ctermfg=yellow          ctermbg=black           cterm=bold

hi Directory    ctermfg=blue

" Statusline/Tabline {{{2
hi StatusLine   ctermfg=white           ctermbg=black           cterm=NONE
hi StatusLineNC ctermfg=darkgrey        ctermbg=black           cterm=NONE
hi WinSeparator ctermfg=darkgrey        ctermbg=NONE            cterm=NONE

" Ex Messages {{{2
hi WarningMsg   ctermfg=black           ctermbg=yellow
hi ErrorMsg     ctermfg=black           ctermbg=red
hi ModeMsg      ctermfg=cyan                                    cterm=bold
hi Question     ctermfg=green
hi WildMenu     ctermfg=black           ctermbg=grey
hi Title        ctermfg=darkgrey        ctermbg=NONE            cterm=bold

" Spelling {{{2
hi SpellBad     ctermfg=red             ctermbg=NONE            cterm=underline
hi SpellLocal   ctermfg=yellow          ctermbg=NONE            cterm=underline
hi SpellCap     ctermfg=NONE            ctermbg=NONE            cterm=underline
hi SpellRare    ctermfg=blue            ctermbg=NONE            cterm=underline

" Searching {{{2
hi Search       ctermfg=black           ctermbg=blue            cterm=NONE
hi IncSearch    ctermfg=black           ctermbg=cyan            cterm=NONE

" Gutter {{{2
hi LineNr       ctermfg=darkblue
hi CursorLineNr ctermfg=blue            ctermbg=NONE            cterm=bold
hi FoldColumn   ctermfg=blue            ctermbg=NONE
hi SignColumn   ctermfg=white           ctermbg=NONE

" Lines {{{2
hi ColorColumn                          ctermbg=darkgrey
hi CursorColumn                         ctermbg=darkgrey
hi CursorLine                           ctermbg=black cterm=NONE
hi Folded       ctermfg=green           ctermbg=black

" Diff {{{2
hi DiffAdd      ctermfg=green           ctermbg=NONE
hi DiffDelete   ctermfg=red             ctermbg=NONE
hi DiffChange   ctermfg=yellow          ctermbg=NONE
hi DiffText     ctermfg=lightyellow     ctermbg=NONE

" Popup Menu {{{2
hi Pmenu        ctermfg=grey            ctermbg=black
hi PmenuSel     ctermfg=fg              ctermbg=black           cterm=NONE
hi PmenuSbar    ctermfg=fg              ctermbg=NONE
hi NormalFloat  ctermfg=fg              ctermbg=black

"  █▓▒░ Syntax colors {{{1

hi Comment      ctermfg=darkgrey

hi Constant     ctermfg=darkmagenta
hi link @constant.builtin Constant
hi link @variable.css Constant

hi String       ctermfg=green
hi link Character String

hi Identifier   ctermfg=fg                                      cterm=NONE
hi @variable.builtin cterm=italic

hi @function ctermfg=cyan
hi link @function.builtin NONE

hi Statement    ctermfg=red
hi Operator     ctermfg=white

hi @attribute ctermfg=yellow
hi link @property.css @attribute

hi PreProc      ctermfg=yellow
hi link @keyword.directive PreProc
hi link @keyword.import PreProc

hi Type         ctermfg=darkblue
hi StorageClass ctermfg=yellow
hi link @keyword.storage StorageClass
hi link @type.qualifier StorageClass

hi Structure    ctermfg=green
hi link Typedef Structure

hi Special      ctermfg=lightgrey
hi Tag          ctermfg=cyan                                    cterm=underline
hi link @markup.link Tag
hi SpecialComment ctermfg=lightgrey
hi Delimiter    ctermfg=fg
hi link @tag.delimiter Delimiter

hi Error        ctermfg=white           ctermbg=darkred

hi Todo         ctermfg=yellow          ctermbg=NONE            cterm=italic
hi link @comment.todo Todo
