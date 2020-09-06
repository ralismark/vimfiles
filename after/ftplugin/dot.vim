setlocal makeprg=dot\ -Tpdf\ %\ -o/tmp/preview.pdf
let b:undo_ftplugin .= '|setl makeprg<'
