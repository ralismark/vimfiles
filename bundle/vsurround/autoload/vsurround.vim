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

function! vsurround#run(motion) " {{{
	let char = getcharstr()
	let opens = ""
	let closes = ""
	if char ==# "\<Esc>" || char ==# "\<C-C>"
		" We return to normal mode on cancel
		exec "normal! \<esc>"
		return
	elseif char ==# "\<C-X>"
		let s = input("Surround with: ")
		let opens = s
		let closes = s
	else
		let [opens, closes] = get(g:vsurround#pairs, char, [char, char])
	endif

	if a:motion ==# "line"
		'[,']s/^\(\s*\)\(.\+\)$/\=submatch(1) . opens . submatch(2) . closes
	elseif a:motion ==# "block"
		let [left, right] = sort([virtcol("'["), virtcol("']")], "n")
		let width = right + 1 - left
		let pattern = '\%' . left . 'v.*\%<' . (right + 2) . 'v'
		exec "'<,'>s/" . pattern . '/\=opens . submatch(0) . repeat(" ", width - len(submatch(0))) . closes'
	elseif a:motion ==# "char"
		s/\%'\[.*\%'\]./\=opens . submatch(0) . closes
		normal! g`[
	elseif a:motion ==# "V"
		exec "normal! \<esc>"
		'<,'>s/^\(\s*\)\(.\+\)$/\=submatch(1) . opens . submatch(2) . closes
	elseif a:motion ==# "\<c-v>"
		exec "normal! \<esc>"
		let [left, right] = sort([virtcol("'<"), virtcol("'>")], "n")
		let width = right + 1 - left
		let pattern = '\%' . left . 'v.*\%<' . (right + 2) . 'v'
		exec "'<,'>s/" . pattern . '/\=opens . submatch(0) . repeat(" ", width - len(submatch(0))) . closes'
		normal! g`<
	elseif a:motion ==# "v"
		exec "normal! \<esc>"
		s/\%'<.*\%'>./\=opens . submatch(0) . closes
		" TODO jump to correct one of '< or '> depending on where cursor initially was
		normal! g`<
	endif
endfunction " }}}
