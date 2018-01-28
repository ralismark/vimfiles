" Emacs type header specification detection
" Author: Timmy Yao
" Version: 0.1.0
" Last Modified: 27 October 2016

" This script intends to match the emacs mode header, which is declared
" between a pair of '-*-' sequences

augroup etypehead
	au!
	au BufReadPost,FileReadPost * call etypehead#set_ftype()
augroup END
