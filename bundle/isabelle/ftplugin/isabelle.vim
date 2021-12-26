" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

setl commentstring=(*\ %s\ *)
setl expandtab tabstop=2

let b:undo_ftplugin = 'setl commentstring< expandtab< tabstop<'
