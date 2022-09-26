" vimrc supplementing file for lightline

fun! ll#nonfile() " {{{1
	let name = bufname('')
	if (&buftype == 'nofile' && (name =~ '^__' || name =~ '^man://'))
	\ || &buftype == 'help'
	\ || &buftype == 'quickfix'
	\ || &buftype == 'terminal'
		return 1
	endif

	return 0
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

fun! ll#relpath() " {{{1
	let path = split(expand("%:p"), "/")
	let cwd = split(getcwd(), "/")
	while len(path) >= 2 && !empty(cwd) && path[0] == cwd[0]
		call remove(path, 0)
		call remove(cwd, 0)
	endwhile
	return join(repeat([".."], len(cwd)) + path, "/")
endfun

fun! ll#abspath() " {{{1
	let path = expand("%:~")
	let usermount = "~/.local/mount/"
	if path[:len(usermount) - 1] == usermount
		let path = "~" . path[len(usermount):]
	endif
	return path
endfun

fun! ll#filename() " {{{1
	if ll#nonfile()
		return ''
	endif

	if bufname('') == ''
		return '-'
	" elseif winwidth(0) > 75
	" 	return substitute(expand("%:~:."), '\([^/]\{1,3}\)[^/]*/', '\1/', 'g')
	else
		let relpath = ll#relpath()
		let abspath = ll#abspath()
		let path = len(relpath) <= len(abspath) ? relpath : abspath
		let pat = '^\([^/]*\)/[^/]*/[^/]*/'
		while len(path) > winwidth(0) / 2 && match(path, pat) == 0
			let path = substitute(path, pat, '\1/…/', '')
		endwhile
		return path
	endif
endfun

fun! ll#special(winid) " {{{1
	let wi = get(getwininfo(a:winid), 0, {})
	let bn = bufname('#' . get(wi, 'bufnr', -1))

	return (!&modifiable && !&buflisted)
	\ || bn =~ '^man://'
	\ || get(wi, 'quickfix')
endfun

fun! ll#filename2() " {{{1
	let bn = bufname('')
	let wi = get(getwininfo(win_getid()), 0, {})
	if !&modifiable && !&buflisted
		" Plugins
		return fnamemodify(bn, ':t')
	elseif bn =~ '^man://'
		return expand('%:t')
	elseif get(wi, 'loclist')
		return 'Location List'
	elseif get(wi, 'quickfix')
		return 'Quickfix List'
	endif
	return ''
endfun

fun! ll#filetype() " {{{1
	if ll#nonfile()
		return ''
	endif
	let ft = &ft == '' ? 'no ft' : &ft
	return ft
endfun

fun! ll#locpercent() " {{{1
	let cur = line('.')
	let top = 1
	let bot = line('$')

	if line('w0') == top && line('w$') == bot
		return 'all'
	elseif line('w$') == bot
		return "bot"
	elseif line('w0') == top
		return "top"
	else
		let prog = cur * 100 / bot
		return printf('%02d%%', prog)
	endif
endfun

fun! ll#location() " {{{1
	return printf('%s %3d:%-2d', ll#locpercent(), line('.'), col('.'))
endfun

fun! ll#rostate() " {{{1
	if ll#nonfile()
		return ''
	endif

	let modified_char = '+'
	return (&modified ? modified_char : &modifiable ? 'w' : 'r') . (&readonly ? '!' : '')
endfun

fun! ll#eol() " {{{1
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

	return eol
endfun

fun! ll#fileinfo() " {{{1
	return ll#filetype() . ' '. ll#eol() . ' '. &fenc
endfun

fun! ll#wordcount() " {{{1
	if !&spell || winwidth(0) < 50
		return ""
	endif

	let wc = wordcount()

	let xwords = has_key(wc, 'cursor_words') ? wc.cursor_words : wc.visual_words

	return 'words: ' . xwords . '/' . wc.words
endfun

fun! ll#lsp() " {{{1
	let clients = luaeval("vim.tbl_values(vim.tbl_map(function(x) return x.name end, vim.lsp.buf_get_clients()))")
	if len(clients) > 0
		return "lsp:" . join(uniq(sort(clients)), " ")
	endif
	return ""
endfunc