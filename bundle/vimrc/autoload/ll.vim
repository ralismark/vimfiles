" vimrc supplementing file for lightline

fun! ll#depth() " {{{1
	return ($vim_depth ? 'depth ' . $vim_depth : '')
endfun

fun! ll#bufinfo() " {{{1
	let cur_buf = bufnr('%')
	let end_buf = bufnr('$')

	let cur_tab = tabpagenr()
	let end_tab = tabpagenr('$')

	let buf_str = 'b' . cur_buf . '/' . end_buf
	let tab_str = 't' . cur_tab . '/' . end_tab

	return buf_str . (end_tab != 1 ? ' : ' . tab_str : '')
endfun

fun! ll#filename() " {{{1
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
endfun

fun! ll#filetype() " {{{1
	let ft = &ft == '' ? 'no ft' : &ft
	return ft
endfun

fun! ll#locpercent() " {{{1
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

fun! ll#location() " {{{1
	if winwidth(0) > 60
		return printf('%s %3d:%-2d', ll#locpercent(), line('.'), col('.'))
	else
		return printf("%3d", line("."))
	endif
endfun

fun! ll#rostate() " {{{1
	if &ft =~? 'help' || expand('%:t') =~? '__Gundo__\|__Gundo_Preview__'
		return ''
	endif

	let modified_char = '+'
	return (&modified ? modified_char : &modifiable ? 'w' : 'r') . (&readonly ? '!' : '')
endfun

fun! ll#fileinfo() " {{{1
	let eol = &ff == 'dos' ? '\r\n' : &ff == 'unix' ? '\n' : '\r'

	if &ff == 'dos' && (has('win32') || has('win64'))
		let eol = ''
	endif
	if &ff == 'unix' && (has('unix') || has('macunix'))
		let eol = ''
	endif
	if &ff == 'mac' && has('mac')
		let eol = ''
	endif

	return ll#filetype() . ' '. eol . ' '. &fenc
endfun

fun! ll#wordcount() " {{{1
	if !&spell || winwidth(0) < 50
		return ""
	endif

	let wc = wordcount()

	let xwords = has_key(wc, 'cursor_words') ? wc.cursor_words : wc.visual_words

	return 'words: ' . xwords . '/' . wc.words
endfun
