" Basically the same thing as cpp.vim
runtime! syntax/doxygen.vim
setlocal commentstring=//%s
let b:undo_ftplugin .= '|setl commentstring<'
