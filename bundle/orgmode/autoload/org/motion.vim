" Org Mode Motions
" Maintainer: Timmy Yao
" Latest Revision: 23 November 2017
"
" This provides various motions to move around a document

" Move to next heading, equivalent to org-next-visible-heading
function! org#motion#next_heading()
	try
		/^\*
	catch /^Vim\%((\a\+)\)\=:E486/
	endtry
endfunction

" Move to previous heading, equivalent to org-previous-visible-heading
function! org#motion#prev_heading()
	try
		?^\*
	catch /^Vim\%((\a\+)\)\=:E486/
	endtry
endfunction

" Move to next heading at the same level
function! org#motion#next_heading_same_level()
	let current_headline = search('^\*', 'bcnW')
	if current_heading == 0
		" No heading, just go to next heading
		try
			/^\*
		catch /^Vim\%((\a\+)\)\=:E486/
		endtry
	else
	endif
	let heading_depth = current_heading ? getline(
endfunction
