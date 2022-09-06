" Vim indent file
" Language: Isabelle/HOL

if exists('b:did_indent')
	finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal autoindent
setlocal indentexpr=v:lua.require'isabelle'.indent(v:lnum)
