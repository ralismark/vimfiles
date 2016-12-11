" Vim compiler file
" Compiler:         variable-defined cc and cflags
" Maintainer:       Timmy Yao
" Latest Revision:  2016-05-29

if exists("current_compiler")
	finish
endif
let current_compiler = "envcc"

let &l:makeprg = ''
if &ft == "c"
	let &l:makeprg = $cc . " -x c"
elseif &ft == "cpp"
	let &l:makeprg = $cxx . " -x c++"
endif
let &l:makeprg .= ' ' . $cflags . ' % $*'
