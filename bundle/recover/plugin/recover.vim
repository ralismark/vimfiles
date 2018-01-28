" A better response to recover prompts
" Author: Timmy Yao
" Version: 0.1.0
" Last Modified: 29 December 2017
"
" This plugin provides an automatic response to swapexists prompts, deleting
" it or showing a diff.

augroup recover
	au!
	au SwapExists * call recover#swapexists()
augroup END
