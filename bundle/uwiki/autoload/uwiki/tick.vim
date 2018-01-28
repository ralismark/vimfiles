" Handle checkbox behaviour, such as ticking/unticking them
"
" Within a list (ordered or unordered), items can be checkboxes, indicating
" tasks which need to be, have been, or are currently being done. This is done
" by having the string '[ ]' just after the list indicator.
"
" Instead of a space, a checkbox may have '-' (default), '.', 'o' or 'O' for
" partially complete tasks, or 'x' (default) or 'X' for completed ones.
"
" e.g. - [ ] Get eggs

" Get the offset of a checkbox on the given line, or -1 if not found
function! uwiki#tick#checkbox_offset(line)

	" Get the line first for easy use

	let content = getline(a:line)

	" Checkboxes only exist in lists. A regex is able firstly find if the
	" line is a list. They may be:
	"  - unordered, beginning with '-', '*' or '+'
	"  - ordered, with digits followed by ')' or '.'
	"
	" We get the first character after the list with \zs to set the
	" beginning to the end. We also skip past whitespace at the end of the
	" match here

	let listpos = match(content, '^\s*\([-*+]\|\d\+[).]\)\s*\zs')

	" Early exit if not a list

	if listpos == -1
		return -1
	endif

	" Then find a checkbox just after the list indicator

	let checkpos = match(content, '^\[[- xX.oO]\]', listpos)

	return checkpos

endfunction

" Get the character inside the checkbox, or empty
function! uwiki#tick#get_check_mark(line)

	" Get the offset first
	let offset = uwiki#tick#checkbox_offset(a:line)

	" Return empty string if not a checkbox

	if offset == -1
		return ''
	endif

	" Get the 2nd character after the start of the checkbox

	return getline(a:line)[offset + 1]

endfunction

" Get the state of the checkbox:
" - 0 if not done
" - 1 if partially done
" - 2 if done
" - -1 if not a tick box
function! uwiki#tick#get_check_state(line)

	" Use get_check_mark for this

	let mark = uwiki#tick#get_check_mark(a:line)

	" Just case

	if mark == ' '
		return 0
	elseif mark =~ '[-.oO]'
		return 1
	elseif mark =~ '[xX]'
		return 2
	endif

	" Default to -1
	return -1

endfunction

" Expression to make the current list item a checkbox (from normal mode)
function! uwiki#tick#expr_add_mark(line)

	" Only do this if the current line is not already a mark

	if uwiki#tick#checkbox_offset(a:line) != -1
		return ''
	endif

	" Do the same check as in checkbox_offset

	let listpos = match(getline(a:line), '^\s*\([-*+]\|\d\+[).]\)\s*\zs')

	" Add only if the line is a list

	if listpos == -1
		return ''
	endif

	" Go to column, add [ ], escape

	let expr = listpos . '|' . "a[ ] \<Esc>"

	" Restore cursor position if we're on the same line

	if a:line == line('.')
		let expr .= (col('.') + 4) . '|'
	endif

	return expr

endfunction

" Expression to change the current mark (from normal mode)
function! uwiki#tick#expr_cycle_state(line)

	" We need both the offset and the actual state

	let offset = uwiki#tick#checkbox_offset(a:line)
	let state = uwiki#tick#get_check_state(a:line)

	" Add box if not a checkbox
	if offset == -1
		return uwiki#tick#expr_add_mark(a:line)
	endif

	" Get the character for the next state

	if state == 0
		let next_mark = '-'
	elseif state == 1
		let next_mark = 'x'
	else " state == 2
		let next_mark = ' '
	endif

	" Replace

	let expr = (offset + 2) . '|' . 'r' . next_mark

	" Restore cursor position if we're on the same line

	if a:line == line('.')
		let expr .= col('.') . '|'
	endif

	return expr

endfunction

