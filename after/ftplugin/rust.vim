setlocal makeprg=cargo\ build
let b:undo_ftplugin .= '|setl makeprg<'
