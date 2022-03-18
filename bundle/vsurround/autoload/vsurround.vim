if !exists("vsurround#pairs")
	let vsurround#pairs = {
	\ "(": ["(", ")"],
	\ ")": ["(", ")"],
	\ "{": ["{", "}"],
	\ "}": ["{", "}"],
	\ "[": ["[", "]"],
	\ "]": ["[", "]"],
	\ "<": ["<", ">"],
	\ ">": ["<", ">"],
	\ }
endif

function! vsurround#wrap_line(open, close, fromline, toline) " {{{
	exec fromline . "," . toline . 's/^\(\s*\)\(.\+\)$/\=submatch(1) . openchar . submatch(2) . closechar'
endfunction " }}}

function! vsurround#run(motion) " {{{
	let char = getcharstr()
	if char =~ "\<Esc>" || char =~ "\<C-C>"
		" We return to normal mode on cancel
		exec "normal! \<esc>"
		return
	endif

	let [openchar, closechar] = get(g:vsurround#pairs, char, [char, char])

	if a:motion ==# "line"
		'[,']s/^\(\s*\)\(.\+\)$/\=submatch(1) . openchar . submatch(2) . closechar
	elseif a:motion ==# "block"
		let width = virtcol("'>") + 1 - virtcol("'<")
		let pattern = '\%' . virtcol("'[") . 'v.*\%<' . (virtcol("']") + 2) . 'v'
		exec "'<,'>s/" . pattern . '/\=openchar . submatch(0) . repeat(" ", width - len(submatch(0))) . closechar'
	elseif a:motion ==# "char"
		s/\%'\[.*\%'\]./\=openchar . submatch(0) . closechar
		normal! g`[
	elseif a:motion ==# "V"
		exec "normal! \<esc>"
		'<,'>s/^\(\s*\)\(.\+\)$/\=submatch(1) . openchar . submatch(2) . closechar
	elseif a:motion ==# "\<c-v>"
		exec "normal! \<esc>"
		let width = virtcol("'>") + 1 - virtcol("'<")
		let pattern = '\%' . virtcol("'<") . 'v.*\%<' . (virtcol("'>") + 2) . 'v'
		exec "'<,'>s/" . pattern . '/\=openchar . submatch(0) . repeat(" ", width - len(submatch(0))) . closechar'
		normal! g`<
	elseif a:motion ==# "v"
		exec "normal! \<esc>"
		s/\%'<.*\%'>./\=openchar . submatch(0) . closechar
		" TODO jump to correct one of '< or '> depending on where cursor initially was
		normal! g`<
	endif
endfunction " }}}
