setlocal makeprg=dot\ -Tpdf\ %\ -o/tmp/preview.pdf

let s:undo = 'setl makeprg<'

if !exists('b:undo_ftplugin')
	let b:undo_ftplugin = s:undo
else
	let b:undo_ftplugin .= '|' . s:undo
endif
