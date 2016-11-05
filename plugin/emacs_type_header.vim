" Emacs type header specification detection
" Author: Timmy Yao
" Version: 0.1.0
" Last Modified: 27 October 2016

" This script intends to match the emacs mode header, which is declared
" between a pair of '-*-' sequences

if !exists('g:etypehead#type_map')
	let g:etypehead#type_map = {
	\ 'c++':        'cpp',
	\ 'c':          'c',
	\ }
endif

" Returns a number indicating the first non-blank line
function! s:first_nonblank_line()
	for i in range(1, line('$'))
		let line = getline(i)
		if match(line, '\S') > -1
			return i
		endif
	endfor
endfunction

" get string inside markers
function! s:get_modeline(lnum)
	let str = matchstr(getline(a:lnum), '-\*-\s*\zs.\{-}\ze\s*-\*-')
	if match(str, ';\|:') > -1
		return matchstr(str, 'mode\s*:\s*\zs.\{-}\ze\s*;')
	else " just the string
		return str
	endif
endfunction

" convert emacs mode to vim filetype
function! s:match_type(type)
	if a:type =~ '^\s*$'
		return &ft
	endif

	let type = tolower(a:type)

	for key in keys(g:etypehead#type_map)
		if type == key
			return map[key]
		endif
	endfor

	return type
endfunction

au! BufReadPost,FileReadPost * let &ft = s:match_type(s:get_modeline(s:first_nonblank_line()))
