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
hi      Normal             ctermfg=white           guibg=NONE
hi      Conceal            ctermfg=NONE            ctermbg=black
hi      NonText            ctermfg=darkgrey
hi      SpecialKey         ctermfg=darkblue
hi      Visual             ctermfg=white           ctermbg=red
hi link VisualNOS          Visual
hi      MatchParen         ctermfg=yellow          ctermbg=black           cterm=bold
hi      SnippetTabStop     ctermfg=darkgrey                                cterm=italic

hi      Directory          ctermfg=blue

" Statusline/Tabline {{{2
hi      StatusLine         ctermfg=white           ctermbg=NONE            cterm=NONE
hi      StatusLineNC       ctermfg=darkgrey        ctermbg=NONE            cterm=NONE
hi      WinSeparator       ctermfg=darkgrey        ctermbg=NONE            cterm=NONE

" Ex Messages {{{2
hi      WarningMsg         ctermfg=black           ctermbg=yellow
hi      ErrorMsg           ctermfg=black           ctermbg=red
hi      ModeMsg            ctermfg=cyan                                    cterm=bold
hi      Question           ctermfg=green
hi      WildMenu           ctermfg=black           ctermbg=grey
hi      Title              ctermfg=darkgrey        ctermbg=NONE            cterm=bold

" Spelling {{{2
hi      SpellBad           ctermfg=red             ctermbg=NONE            cterm=underline
hi      SpellLocal         ctermfg=yellow          ctermbg=NONE            cterm=underline
hi      SpellCap           ctermfg=NONE            ctermbg=NONE            cterm=underline
hi      SpellRare          ctermfg=blue            ctermbg=NONE            cterm=underline

" Searching {{{2
hi      Search             ctermfg=black           ctermbg=blue            cterm=NONE
hi      IncSearch          ctermfg=black           ctermbg=cyan            cterm=NONE

" Gutter {{{2
hi      LineNr             ctermfg=darkblue
hi      CursorLineNr       ctermfg=blue            ctermbg=NONE            cterm=bold
hi      FoldColumn         ctermfg=blue            ctermbg=NONE
hi      SignColumn         ctermfg=white           ctermbg=NONE

" Lines {{{2
hi      ColorColumn                                ctermbg=darkgrey
hi      CursorColumn                               ctermbg=darkgrey
hi      CursorLine                                 ctermbg=black           cterm=NONE
hi      Folded             ctermfg=green           ctermbg=black

" Diff {{{2
hi      DiffAdd                                    ctermbg=22
hi      DiffDelete                                 ctermbg=52
hi      DiffChange                                 ctermbg=94
hi      DiffText           ctermfg=lightyellow     ctermbg=94

" Popup Menu {{{2
hi      Pmenu              ctermfg=grey            ctermbg=black
hi      PmenuSel           ctermfg=fg              ctermbg=black           cterm=NONE
hi      PmenuSbar          ctermfg=fg              ctermbg=NONE
hi      NormalFloat        ctermfg=fg              ctermbg=black

"  █▓▒░ Syntax colors {{{1

hi      Comment            ctermfg=darkgrey

hi      Constant           ctermfg=darkmagenta

hi      String             ctermfg=green
hi link Character          String

hi      Identifier         ctermfg=fg                                      cterm=NONE
hi      @variable.builtin                                               cterm=italic

hi      @function          ctermfg=cyan

hi      Statement          ctermfg=red
hi      Operator           ctermfg=white

hi      @attribute         ctermfg=yellow

hi      PreProc            ctermfg=yellow

hi      Type               ctermfg=darkblue
hi      StorageClass       ctermfg=yellow

hi      Structure          ctermfg=green
hi link Typedef            Structure

hi      Special            ctermfg=lightgrey
hi      Tag                ctermfg=cyan                                    cterm=underline
hi      SpecialComment     ctermfg=lightgrey
hi      Delimiter          ctermfg=fg

hi      Error              ctermfg=white           ctermbg=darkred

hi      Todo               ctermfg=yellow          ctermbg=NONE            cterm=italic

" Tree-sitter Overrides

" explicitly want to reset to Normal
hi link @none Normal

hi link @property.css      @attribute
hi link @tag.attribute     @attribute

hi link @constant.builtin  Constant
hi link @variable.css      Constant

hi link @tag.delimiter     Delimiter

hi link @function.builtin  NONE " nothing special

hi link @keyword.directive PreProc
hi link @keyword.import    PreProc

hi link @keyword.storage   StorageClass
hi link @type.qualifier    StorageClass

hi link @markup.link       Tag

hi link @comment.todo      Todo
