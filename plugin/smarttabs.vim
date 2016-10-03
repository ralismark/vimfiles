" Intelligent Indent
" Author: Timmy Yao
" Version: 0.9.0
" Last Modified: 26 September 2016

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
" g:ctab_disable_tab_maps
"   disable tab insertion and deletion mappings

if !exists('g:ctab_disable_tab_maps') || !g:ctab_disable_tab_maps
	imap <silent> <expr> <tab> <SID>InsertSmartTab()
	inoremap <silent> <expr> <BS> <SID>DoSmartDelete()
endif

" Insert a smart tab.
fun! s:InsertSmartTab()
	if strpart(getline('.'), 0, col('.') - 1) =~'^\s*$'
		if exists('b:ctab_hook') && b:ctab_hook != ''
			exe 'return '.b:ctab_hook
		endif
		return "\<Tab>"
	endif

	return repeat(' ', 8 - (virtcol('.') % 8) + 1)
endfun

" Do a smart delete.
fun! s:DoSmartDelete()
	let line = getline('.')
	let pos = col('.') - 1
	let ident_sz = strlen(matchstr(line, '^\t* *'))
	let tab_sz  = strlen(matchstr(line, '^\t*'))
	if pos > ident_sz || pos <= tab_sz
		return "\<BS>"
	else
		return repeat("\<BS>", ident_sz - tab_sz)
	endif
endfun

" Check the alignment of line.
" Used in the case where some alignment whitespace is required .. like for unmatched brackets.
" It does this by using a massive tabstop and shiftwidth
fun! s:CheckAlign(line)
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
			let b:ctab_lastalign = a:line
		elseif exists('b:ctab_lastalign')
			unlet b:ctab_lastalign
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
	let mov_seq = getline(a:line) =~ '^\s*$' ? "\<esc>^a" : repeat("\<right>", vcol - indatabs * shiftwidth() + indaspace - 1)

	return "\<home>^\<c-d>" . repeat("\<tab>", indatabs) . repeat(' ', indaspace) . mov_seq
endfun

" get SID of current script
fun! s:SID()
	return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun
" Get the spaces at the end of the  indent correct.
" This is trickier than it should be, but this seems to work.
fun! s:CheckCR()
	" echo 'SID:'.s:SID()
	if getline('.') =~ '^\s*$'
		if ('cpo' !~ 'I') && exists('b:ctab_lastalign') && (line('.') == b:ctab_lastalign)
			return "^\<c-d>\<CR>"
		endif
		return "\<CR>"
	else
		return "\<CR>\<c-r>=<SNR>".s:SID().'_CheckAlign(line(''.''))'."\<CR>"
	endif
endfun

inoremap <silent> <expr> <cr> <SID>CheckCR()
nnoremap <silent> o o<c-r>=<SID>CheckAlign(line('.'))<cr>
nnoremap <silent> O O<c-r>=<SID>CheckAlign(line('.'))<cr>

" indentkeys and cinkeys break from the indents

" Ok.. now re-evaluate the = re-indented section

" The only way I can think to do this is to remap the =
" so that it calls the original, then checks all the indents.
map <silent> <expr> = <sid>SetupEqual()

fun! s:SetupEqual()
	set operatorfunc=CtabRedoIndent
	" Call the operator func so we get the range
	return 'g@'
endfun

fun! CtabRedoIndent(type,...)
	set operatorfunc=
	let ln=line("'[")
	let lnto=line("']")
	" Do the original equals
	norm! '[=']

	if ! &et
		" Then check the alignment.
		while ln <= lnto
			silent call s:CheckAlign(ln)
			let ln+=1
		endwhile
	endif
endfun
