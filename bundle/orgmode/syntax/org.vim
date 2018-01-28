" Vim Syntax File
" Language: Org Mode
" Maintainer: Timmy Yao
" Latest Revision: 23 November 2017
"
" This syntax file is based off http://orgmode.org/worg/dev/org-syntax.html.
" Deviations from that and other documented syntax may exist, as well as
" incorrect interpretations and misunderstandings. Edge cases may also not be
" correctly handled
"
" TODO tables

if exists('b:current_syntax')
	finish
endif

"
" Overall highlighting
"
hi def link orgObject Operator
hi def link orgToken Operator
hi def link orgBullet Statement

" Headline format
syn region orgHeadline matchgroup=orgHeadlineMarker start="^\*\+" end="$" oneline contains=orgTodoMarker,orgHeadlineTags,@orgObject skipnl nextgroup=orgPlanning
syn keyword orgTodoMarker TODO DONE contained skipwhite nextgroup=orgTodoPriority
syn match orgTodoPriority "\[#[ABC]\]" contained
syn match orgHeadlineTags ":\([[:alnum:]_@#%]\+:\)\+" contained

hi def link orgHeadlineMarker Special
hi def link orgTodoMarker Todo
hi def link orgTodoPriority orgToken
hi def link orgHeadlineTags Type

" Plain list format
syn match orgUBullet "^\s*\(\zs[-+]\|\s\zs\*\)\ze\(\s\|$\)" skipwhite nextgroup=orgDescription,orgCounterSet,orgCheckbox
syn match orgOBullet "^\s*\zs\(\d\+\|\a\)[).]\ze\s" skipwhite nextgroup=orgCounterSet,orgCheckbox,orgDescription
syn match orgDescription "\S.\{-\}\ze\s*::" contained skipwhite nextgroup=orgDescriptionMarker
syn match orgDescriptionMarker "::" contained
syn match orgCounterSet "\[@\(\d\+\|\a\)\]" contained skipwhite nextgroup=orgCheckbox,orgDescription
syn match orgCheckbox "\[[ Xx-]\]" contained skipwhite nextgroup=orgDescription

hi def link orgUBullet orgBullet
hi def link orgOBullet orgBullet
hi def link orgCounterSet orgToken
hi def link orgCheckbox orgToken

" Equivalent of folds for org-mode
syn region orgDrawer matchgroup=orgDrawerLabel start="^:\(END:\)\@![[:alnum:]_-]*:$" end="^:END:$" contains=TOP fold

hi def link orgDrawerLabel PreProc

" All the #+ stuff (generic catch-all)
syn match orgKeyword "^#+.*$"

hi def link orgKeyword Comment

" Timestamps
let s:ts_date = '\d\d\d\d-\d\d-\d\d\(\s\+[^[:blank:][:digit:]+\]>-]\+\)\?'
let s:ts_time = '\d\d\?:\d\d'
let s:ts_rep_or_delay = '\(+\|++\|\.+\|-\|--\)\d\+[hdwmy]'
let s:ts_item = s:ts_date . '\( ' . s:ts_time . '\)\?\( ' . s:ts_rep_or_delay . '\)\{,2\}'
let s:ts_range = s:ts_date . ' ' . s:ts_time . '-' . s:ts_time . '\( ' . s:ts_rep_or_delay . '\)\{,2\}'

exec 'syn match orgTimestampActive "<' . s:ts_item . '>"'
exec 'syn match orgTimestampInactive "\[' . s:ts_item . '\]"'
exec 'syn match orgTimestampActiveRange "<' . s:ts_item . '>--<' . s:ts_item . '>"'
exec 'syn match orgTimestampActiveTRange "<' . s:ts_range . '>"'
exec 'syn match orgTimestampInactiveRange "\[' . s:ts_item . '\]--\[' . s:ts_item . '\]"'
exec 'syn match orgTimestampInactiveTRange "\[' . s:ts_range . '\]"'

syn cluster orgTsActive contains=orgTimestampActive,orgTimestampActiveRange,orgTimestampActiveTRange
syn cluster orgTsInactive contains=orgTimestampInactive,orgTimestampInactiveRange,orgTimestampInactiveTRange
syn cluster orgTimestamp contains=@orgTsActive,@orgTsInactive

hi def link orgTimestampActive orgTimestamp
hi def link orgTimestampInactive orgTimestamp
hi def link orgTimestampActiveRange orgTimestamp
hi def link orgTimestampActiveTRange orgTimestamp
hi def link orgTimestampInactiveRange orgTimestamp
hi def link orgTimestampInactiveTRange orgTimestamp

hi def link orgTimestamp Constant

" Clock
syn region orgClock start="^CLOCK:" end="=> \d\+:\d\d$" oneline contains=@orgTimestamp

" Planning
syn match orgPlanning "\(DEADLINE\|SCHEDULED\|CLOSED\): " nextgroup=@orgTimestamp

hi def link orgPlanning Todo

" Full-line items
syn match orgCommentLine "^#\(\s.*\)\?$"
syn match orgFixedWidthLine "^:\(\s.*\)\?$"
syn match orgHRule "^\s*\zs-\{5,\}$"

hi def link orgCommentLine Comment
hi def link orgFixedWidthLine String
hi def link orgHRule Delimiter

"
" Objects
"

" TODO conceal link brackets
syn match orgRegularLink "\[\[[^\]]*\]\(\[[^\]]*\]\)\?\]"
syn match orgAngleLink "<\w*:[^<>\]]*>"
syn match orgTarget "<<[^<>]*>>"
syn match orgFootnote "\[fn:[[:alpha:]_-]*\(:.\{-\}\)\?\]"
syn match orgLinebreak "\\\\\s*$" " \\SPACE
syn match orgStatistic "\[\d*\(%\|\/\d*\)\]"

syn cluster orgLink contains=orgRegularLink,orgAngleLink
syn cluster orgObject contains=@orgTimestamp,@orgLink,orgTarget,orgFootnote,orgLinebreak,orgStatistic

hi def link orgRegularLink orgLink
hi def link orgAngleLink orgLink
hi def link orgLink Tag

hi def link orgTarget orgObject
hi def link orgFootnote orgObject
hi def link orgLinebreak orgObject
hi def link orgStatistic orgObject
hi def link orgObject orgToken


" hi link orgLinebreak Operator
" hi link orgFixedWidthLine String
" hi link orgCommentLine Comment
" hi link orgGreaterBlock Comment
" hi link orgDescriptionMarker Statement
" hi link orgFootnote Comment
" hi link orgOBullet orgBullet
" hi link orgUBullet orgBullet
" hi link orgBullet Statement
" hi link orgHeadlineMarker Delimiter
" hi link orgTodoMarker Todo
" hi link orgHeadlineTags Identifier
