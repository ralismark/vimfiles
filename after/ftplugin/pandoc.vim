setlocal noexpandtab tabstop=4

" We let dashed lists be comments so they work better with other editing
" features
setlocal commentstring=<!--%s-->
let &l:comments = 'b:-,b:*,b:+,s:<!--,m:    ,e:-->'
setlocal formatoptions=roqnlj

setlocal spell
setlocal wrap

let &l:makeprg = 'pandoc "%" -o ' . g:pdf_out . ' --pdf-engine=tectonic --citeproc $*'

function! PandocFold()
	let depth = match(getline(v:lnum), '\(^#\+\)\@<=\( .*$\)\@=')
	return depth > 0 ? '>' . depth : '='
endfunction

setlocal foldmethod=expr foldexpr=PandocFold()

noremap <expr><buffer> ]] ({p -> p ? p . 'gg' : 'G' })(search('^#', 'Wnz'))
noremap <expr><buffer> [[ ({p -> p ? p . 'gg' : 'gg' })(search('^#', 'Wnbz'))

let b:undo_ftplugin = exists("b:undo_ftplugin") ? b:undo_ftplugin . '|' : ""
let b:undo_ftplugin .= 'setl et< ts< comments< formatoptions< spell< wrap< makeprg< foldmethod< foldexpr<'
let b:undo_ftplugin .= '|silent! unmap [[|silent! unmap ]]'
