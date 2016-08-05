" Vim compiler file
" Compiler:             Clang - LLVM Compiler Toolchain
" Maintainer:           Timmy Yao
" Latest Revision:      2016-07-29

if exists("curent_compiler")
	finish
endif
let current_compiler = 'clang'

let &errorformat  = ''

let &errorformat .= ',%f:%l:%c: note: %m'
let &errorformat .= ',%f:%l:%c: %t%s: %m'
