"
" Statusline stuff
"

function! sl#make(components, splitter)
	call filter(a:components, {i,x -> !empty(x)})
	let out = join(a:components, a:splitter)
	if !empty(out)
		return ' ' . out
	endif
	return ''
endfunction

function! sl#app(component, splitter)
	if empty(a:component)
		return ''
	endif
	return a:splitter . a:component
endfunction

function! sl#generate(w)
	if exists('#goyo')
		return ''
	endif

	let focus = a:w == winnr()

	if focus
		let co = {
		\	1: '%1*',
		\	2: '%2*',
		\	3: '%3*',
		\	4: '%4*',
		\	'ale': '%#SLError#',
		\}
	else
		let co = {
		\	1: '%6*',
		\	2: '%7*',
		\	3: '%8*',
		\	4: '%9*',
		\	'ale': '%#SLErrorI#',
		\}
	endif

	let winid = win_getid(a:w)
	let wininfo = get(getwininfo(winid), 0, {})
	let bufnr = get(wininfo, 'bufnr', -1)

	let stl = ''

	if 0 && ll#special(winid)
		let stl .= co[2] . '' . co[1] . ' %n%{ sl#app(ll#filename2(), "  ") } ' . co[2] . ' '
		let stl .= co[4] . '%<%{ repeat("' . (focus ? '━' : '─') . '", winwidth(0)) }>' " split
		return stl
	endif

	let stl .= co[2] . '' . co[1] . '%{ sl#make([ bufnr(""), ll#filename() ], "  ") } ' . co[2] . ''
	let stl .= co[3] . '%{ sl#make([ ' . (focus ? '&bt, ' : '') . 'll#rostate(), ll#wordcount() ], "  ") }'
	let stl .= co[4] . ' %<%{ repeat("' . (focus ? '━' : '─') . '", winwidth(0)) }>' " split
	let stl .= co[3] . '%{ sl#make([ ll#eol(), ' . (focus ? 'll#filetype()' : 'll#nonfile() ? "" : &ft') . ' ], "  ") } '
	let stl .= co[2] . '' . co[1] . ' ' . co['ale'] . '%{ ll#ale() }' . co[1] . '%{ !empty(ll#ale()) ? "   " : "" }%{ ll#location() } ' . co[2] . ' '

	return stl
endfunction

function! sl#refresh()
	for i in range(1, winnr('$'))
		call setwinvar(i, '&statusline', '%!sl#generate(' . i . ')')
	endfor
endfunction

function! sl#enable()
	" Main bar
	hi User1    ctermfg=black ctermbg=white
	hi User6    ctermfg=black ctermbg=darkgrey
	" Main -> Secondary
	hi User2    ctermfg=white
	hi User7    ctermfg=darkgrey
	" Secondary
	hi User3    ctermfg=white
	hi User8    ctermfg=darkgrey
	" Middle
	hi User4    ctermfg=blue
	hi User9    ctermfg=darkgrey
	" ALE Error
	hi SLError  ctermfg=160   ctermbg=white    cterm=bold,underline
	hi SLErrorI ctermfg=124   ctermbg=darkgrey cterm=bold,underline

	augroup SL
		au!
		au VimEnter,WinEnter,BufWinEnter * call sl#refresh()
		au ColorScheme * call sl#enable()
		au User GoyoEnter nested call sl#disable()
	augroup END

	call sl#refresh()
endfunction

function! sl#disable(...)
	augroup SL
		au!
		if a:0 > 0 && a:1 ==? 'goyo'
			au User GoyoLeave nested call sl#enable()
		else
			for i in range(1, winnr('$'))
				call setwinvar(i, '&statusline', '')
			endfor
		endif
	augroup END
endfunction

au vimrc User GoyoEnter nested call sl#disable('goyo')
au vimrc User GoyoLeave nested call sl#enable()
