" Intelligent Indent
" Author: Timmy Yao
" Version: 0.9.0
" Last Modified: 26 October 2016

" The aim of this script is to be able to handle the mode of tab usage which
" distinguishes 'indent' from 'alignment'.  The idea is to use <tab>
" characters only at the beginning of lines.
"
" This means that an individual can use their own 'tabstop' settings for the
" indent level, while not affecting alignment.
"
" The one caveat with this method of tabs is that you need to follow the rule
" that you never 'align' elements that have different 'indent' levels.
"
" options:
"
" g:itab#disable_maps
"   disable tab insertion and deletion mappings
"
" g:itab#delete_trails
"   delete trailing spaces/tabs when going to a new line

" note: indentkeys and cinkeys partially break from the indents

inoremap <expr> <Esc> itab#delete_trails(1) . "\<esc>"

if !exists('itab#disable_maps') || !itab#disable_maps
	imap <silent> <expr> <tab> itab#tab()
	inoremap <silent> <expr> <BS> itab#delete()
endif

inoremap <silent> <expr> <cr> itab#cr()
nnoremap <silent> o o<c-r>=itab#align(line('.'))<cr>
nnoremap <silent> O O<c-r>=itab#align(line('.'))<cr>

nmap <silent> = :set opfunc=itab#redo_indent<cr>g@
nmap <silent> == :call itab#redo_indent('f', 2)<cr>
vmap <silent> = :<c-u>call itab#redo_indent('', 1)<cr>
