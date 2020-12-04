setlocal noexpandtab tabstop=4

" We let dashed lists be comments so they work better with other editing
" features
setlocal comments=b:-
setlocal formatoptions=roqnlj

setlocal spell
setlocal wrap

let &l:makeprg = 'pandoc "%" -o /tmp/preview.pdf $*'

function! s:PandocFold()
	let depth = match(getline(v:lnum), '\(^#\+\)\@<=\( .*$\)\@=')
	return depth > 0 ? '>' . depth : '='
endfunction

setlocal foldmethod=expr foldexpr=s:PandocFold()

noremap <expr><buffer> ]] ({p -> p ? p . 'gg' : 'G' })(search('^#', 'Wnz'))
noremap <expr><buffer> [[ ({p -> p ? p . 'gg' : 'gg' })(search('^#', 'Wnbz'))

let s:undo  = 'setl et< ts< comments< formatoptions< spell< wrap< makeprg< foldmethod< foldexpr<'
let s:undo .= '|unmap [[|unmap ]]'

if !exists('b:undo_ftplugin')
	let b:undo_ftplugin = s:undo
else
	let b:undo_ftplugin .= '|' . s:undo
endif
