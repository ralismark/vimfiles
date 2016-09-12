" Intelligent Indent
" Author: Michael Geddes < vimmer at frog dot wheelycreek dot net >
" Version: 2.6
" Last Modified: December 2010
"
" Histroy:
"   1.0: - Added RetabIndent command - similar to :retab, but doesn't cause
"         internal tabs to be modified.
"   1.1: - Added support for backspacing over spaced tabs 'smarttab' style
"        - Clean up the look of it by blanking the :call
"        - No longer a 'filetype' plugin by default.
"   1.2: - Interactions with 'smarttab' were causing problems. Now fall back to
"          vim's 'smarttab' setting when inserting 'indent' tabs.
"        - Fixed compat with digraphs (which were getting swallowed)
"        - Made <BS> mapping work with the 'filetype' plugin mode.
"        - Make CTabAlignTo() public.
"   1.3: - Fix removing trailing spaces with RetabIndent! which was causing
"          initial indents to disappear.
"   1.4: - Fixed Backspace tab being off by 1
"   2.0: - Add support for alignment whitespace for mismatched brackets to be spaces.
"   2.1: - Fix = operator
"   2.3: - Fix (Gene Smith) for error with non C files
"        - Add option for filetype maps
"        - Allow for lisp indentation
"   2.4: - Fix bug in Retab
"   2.5: - Fix issue with <CR> not aligning
"   2.6: - Fix issue with alignment not disappearing.

" This is designed as a filetype plugin (originally a 'Buffoptions.vim' script).
"
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
"   disable the (original) tab mappings

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

	let is_eol = col('.') == col('$')
	let pos = getpos('.')

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
	if inda == 0
		return "^\<c-d>"
	endif
	" no of tabs
	let indatabs=inda / big_ident_sz
	" no of spaces
	let indaspace=inda % big_ident_sz

	call setpos('.', pos)
	return "\<home>^\<c-d>" . repeat("\<tab>", indatabs) . repeat(' ', indaspace) . "\<c-o>^a" . (is_eol ? "\<end>" : "")
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
