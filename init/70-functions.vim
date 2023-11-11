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
