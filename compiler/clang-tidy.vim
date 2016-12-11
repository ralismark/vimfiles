" Vim compiler file
" Compiler:		clang-tidy - LLVM Compiler 
" Maintainer:           Timmy Yao
" Latest Revision:      2016-12-09

if exists("current_compiler")
	finish
endif
let current_compiler = 'clang-tidy'

let s:checks = [ '*',
	\ ]

let &makeprg = 'clang-tidy % -checks=' . join(s:checks, ',') . ' -- $*'

let &errorformat = ''
