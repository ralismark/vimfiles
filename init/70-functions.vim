" Functions {{{1

function! GetSynClass() " {{{2
	return map(synstack(line('.'), col('.')), {k,v -> synIDattr(v, "name")})
endfunction

function! OperatorFuncTest(motion) " {{{2
	if a:motion ==# "line"
		normal! `[V`]
	elseif a:motion ==# "char"
		normal! `[v`]
	elseif a:motion ==# "block"
		exec "normal! `[\<c-v>`]"
	endif
endfunction

function! OpenCorresponding() " {{{2
	let candidate_exts = get(g:corresmap, expand("%:e"), [])
	for ext in candidate_exts
		let candidate = expand("%:r") . "." . ext
		if filereadable(candidate)
			exec "edit" candidate
			return
		endif
	endfor
	echoe "No corresponding file found! looked for: " . join(candidate_exts, ", ")
endfunction
let g:corresmap = {
\ "h": ["c", "cpp"],
\ "hpp": ["c", "cpp"],
\ "c": ["h", "hpp"],
\ "cpp": ["h", "hpp"],
\ }
