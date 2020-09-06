" Basically the same thing as c.vim
runtime! syntax/doxygen.vim
setlocal omnifunc= " Setting omnifunc causes problems, apparently
setlocal commentstring=//%s
let b:undo_ftplugin .= '|setl commentstring< omnifunc<'
