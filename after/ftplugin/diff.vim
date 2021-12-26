function! DiffFold()
	let line = getline(v:lnum)
	if match(line, '^@@') >= 0
		return '>2'
	elseif match(line, '^[\\+ -]') >= 0
		return '='
	else
		return 0
	endif
endfunction

setlocal foldmethod=expr foldexpr=DiffFold()
let b:undo_ftplugin .= '| setl foldmethod< foldexpr<'
