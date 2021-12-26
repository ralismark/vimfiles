let &l:makeprg = 'dot -Tpdf % -o' . g:pdf_out
let s:undo = 'setl makeprg<'

if !exists('b:undo_ftplugin')
	let b:undo_ftplugin = s:undo
else
	let b:undo_ftplugin .= '|' . s:undo
endif
