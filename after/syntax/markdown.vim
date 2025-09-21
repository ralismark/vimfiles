" I never use indented codeblocks
syn clear markdownCodeBlock
syn region markdownCodeBlock matchgroup=markdownCodeDelimiter start="^\s*\z(`\{3,\}\).*$" end="^\s*\z1\ze\s*$" keepend
syn region markdownCodeBlock matchgroup=markdownCodeDelimiter start="^\s*\z(\~\{3,\}\).*$" end="^\s*\z1\ze\s*$" keepend

hi def link markdownCode String

" RST-like directives
syn region markdownDirective matchgroup=markdownDirectiveDelimiter start="\.\.\s" end="::" keepend oneline contained nextgroup=markdownDirectiveArg
syn match markdownDirectiveArg ".*\n" contained
syn match markdownDirectiveOpt ":[a-z]\+:"

syn cluster markdownBlock add=markdownDirective

hi def link markdownDirective Function
hi def link markdownDirectiveOpt Keyword

hi markdownCodeDelimiter ctermfg=darkgrey
hi markdownItalicDelimiter ctermfg=darkgrey
hi markdownBoldDelimiter ctermfg=darkgrey
