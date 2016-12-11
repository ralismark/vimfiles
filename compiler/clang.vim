" Vim compiler file
" Compiler:             Clang - LLVM Compiler Toolchain
" Maintainer:           Timmy Yao
" Latest Revision:      2016-07-29

if exists("current_compiler")
	finish
endif
let current_compiler = 'clang'

let s:efm = [
	\ '%f:%l:%c: note: %m',
	\ '%f:%l:%c: %t%s: %m',
	\ '%I' . '%f:%l:%c: note: %m'
	\ .'%C'. '%s'
	\ .'%C'. '%*[ *%~*^%~*]'
	\ ]

let &errorformat = join(s:efm, ',')
