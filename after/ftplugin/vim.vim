" Standard idents, plus hash (autoload) and dollar (environemnt vars)
setlocal iskeyword=@,48-57,_,#,$

let b:undo_ftplugin .= '|setl iskeyword< keywordprg<'
