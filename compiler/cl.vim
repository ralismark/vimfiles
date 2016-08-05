" Vim compiler file
" Compiler:         CL - MS Optimising Compiler / Linker
" Maintainer:       Timmy Yao
" Latest Revision:  2016-04-02

if exists("current_compiler")
	finish
endif
let current_compiler = "cl"

let &errorformat = ''
let &errorformat .= '%f(%l) %\?: %trror C%n: %#%m' . ','
let &errorformat .= '%f(%l) %\?: %tarning C%n: %#%m' . ','
let &errorformat .= '%f(%l) %\?: %tote: %m' . ','

CompilerSet makeprg=cl\ %\ /nologo\ /EHsc\ /W4\ $*
