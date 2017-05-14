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

fun! itab#delete_trails(origin)
	" origin is what caused this call
	" 1: escape
	" 2: enter

	let delete_trail_opt = exists('g:itab#delete_trails') && g:itab#delete_trails
	let current_line = getline('.')

	if delete_trail_opt
		let trail_len = len(matchstr(current_line, '\s*$'))
		return repeat("\<bs>", trail_len)
	endif

	let blank_line = match(current_line, '^\s\+$') != -1
	let cpo_delete = &cpo !~# 'I'
	let last_align = exists('b:itab_lastalign') && (line('.') == b:itab_lastalign)

	let do_delete = 0

	if a:origin == 1
		let do_delete = blank_line
	elseif a:origin == 2
		let do_delete = cpo_delete && blank_line && last_align
	endif

	return do_delete ? "^\<c-d>" : ''
endfun

" Insert a smart tab.
fun! itab#tab()
	if strpart(getline('.'), 0, col('.') - 1) =~'^\s*$'
		if exists('b:itab_hook') && b:itab_hook != ''
			exe 'return '.b:itab_hook
		endif
		return "\<Tab>"
	endif

	return repeat(' ', shiftwidth() - (virtcol('.') % shiftwidth()) + 1)
endfun

" Do a smart delete.
fun! itab#delete()
	if &smarttab
		return "\<bs>"
	endif

	let line = getline('.')
	let pos = col('.') - 1

	let ident_sz = strlen(matchstr(line, '^\t* *'))

	let tab_sz  = strlen(matchstr(line, '^\t*'))
	let space_sz = ident_sz - tab_sz

	if pos > ident_sz || pos <= tab_sz
		return "\<BS>"
	else
		let del_sz = space_sz % shiftwidth()
		return repeat("\<BS>", del_sz == 0 ? shiftwidth() : del_sz)
	endif
endfun

" Check the alignment of line.
" Used in the case where some alignment whitespace is required .. like for unmatched brackets.
" It does this by using a massive tabstop and shiftwidth
fun! itab#align(line)
	if &expandtab || !(&autoindent || &indentexpr || &cindent)
		return ''
	endif

	let big_ident_sz = 80

	let pos = getpos('.')
	let vcol = virtcol('.')

	let pos[1] = a:line

	let tskeep = &tabstop
	let swkeep = &shiftwidth
	try
		if a:line == line('.')
			let b:itab_lastalign = a:line
		elseif exists('b:itab_lastalign')
			unlet b:itab_lastalign
		endif

		let &ts = big_ident_sz
		let &sw = big_ident_sz

		if &indentexpr != ''
			let v:lnum = a:line
			sandbox exe 'let inda=' . &indentexpr
			if inda == -1
				let inda = indent(a:line-1)
			endif
		elseif &cindent
			let inda = cindent(a:line)
		elseif &lisp
			let inda = lispindent(a:line)
		elseif &autoindent
			let inda = indent(a:line)
		elseif &smarttab
			return ''
		else
			let inda = 0
		endif
	finally
		let &ts=tskeep
		let &sw=swkeep
	endtry

	call setpos('.', pos)
	if inda == 0
		return "^\<c-d>"
	endif
	" no of tabs
	let indatabs=inda / big_ident_sz
	" no of spaces
	let indaspace=inda % big_ident_sz

	" indent only: move to end of indent (and make vim think we're there)
	" indent + text: move to original cursor position
	let mov_seq = "\<esc>^a"
	if getline(a:line) !~ '^\s*$'
		let num = vcol - (shiftwidth() - 1) * indatabs - 1
		let mov_seq = "\<home>" . repeat("\<right>", num)
	endif

	return "\<home>^\<c-d>" . repeat("\<tab>", indatabs) . repeat(' ', indaspace) . mov_seq
endfun

" Get the spaces at the end of the indent correct.
" This is trickier than it should be, but this seems to work.
fun! itab#cr()
	return itab#delete_trails(2) . "\<CR>\<c-r>=itab#align(line('.'))" . "\<CR>"
endfun

fun! itab#redo_indent(type, ...)
	let ln   = line("'[")
	let lnto = line("']")

	if exists('a:1') && a:1 ==# 1
		let ln   = line("'<")
		let lnto = line("'>")
	endif

	" Do the original align
	silent exec 'normal! g' . ln . 'Vg' . lnto . '='

	" Then check the alignment.
	while ln <= lnto
		exec 'normal! ' . ln . 'ggA' . itab#align(ln)
		let ln += 1
	endwhile

	return ''
endfun
