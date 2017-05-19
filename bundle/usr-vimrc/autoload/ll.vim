" vimrc supplementing file for lightline

fun! ll#bufinfo() " {{{
	let cur_buf = bufnr('%')
	let end_buf = bufnr('$')

	let cur_tab = tabpagenr()
	let end_tab = tabpagenr('$')

	let lvl_str = 'level ' . $vim_depth
	let buf_str = 'b' . cur_buf . '/' . end_buf
	let tab_str = 't' . cur_tab . '/' . end_tab
endfun " }}}

fun! ll#filename() " {{{
	if expand('%:t') =~? '__Gundo__\|__Gundo_Preview__'
		return ''
	endif

	let bufnum = bufnr('%') . '#'
	let name = expand('%:t') == '' ? '*' : expand('%:t')
	if winwidth(0) > 75
		let fsegs = (['', '', ''] + split(expand('%:p:h'), '/'))[-3:]
		let minisegs = map(fsegs, 'matchstr(v:val, ".\\{,3\\}")')
		let name = join(minisegs, '/') . ' / ' . name
	endif
	return name
endfun " }}}

fun! ll#filetype() " {{{
	let ft = &ft == '' ? 'no ft' : &ft
	return ft
endfun

fun! ll#locpercent() " {{{
	let cur = line('.')
	let top = 1
	let bot = line('$')

	if line('w$') == bot
		return "bot"
	elseif line('w0') == top
		return "top"
	else
		let prog = cur * 100 / bot
		return printf('%02d%%', prog)
	endif
endfun

fun! ll#location() " {{{
	if winwidth(0) > 60
		return printf('%s %3d:%-2d', ll#locpercent(), line('.'), col('.'))
	else
		return printf("%3d", line("."))
	endif
endfun " }}}

fun! ll#rostate() " {{{
	if &ft =~? 'help' || expand('%:t') =~? '__Gundo__\|__Gundo_Preview__'
		return ''
	endif

	let modified_char = '+'
	return (&modified ? modified_char : &modifiable ? 'w' : 'r') . (&readonly ? '!' : '')
endfun

fun! ll#fileinfo() " {{{
	let eol = &ff == 'dos' ? '' : &ff == 'unix' ? '\\n' : '\\r'
	return ll#filetype() . ' '. eol . ' '. &fenc
endfun