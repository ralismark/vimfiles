" MicroWiki
" Author: Timmy Yao
" Version: 0.1.0
" Last Modified: 4 October 2017
"
" Vimwiki is a good plugin, but is too intrusive, making several bindings that
" you may not want. Additionally, it has a weird syntax by default, requiring
" other options to change it to markdown

" <plug> maps

nnoremap <silent> <Plug>UWikiGotoRef :call uwiki#ref#goto_current()<cr>
nnoremap <silent> <Plug>UWikiMakeRef :call uwiki#ref#create()<cr>
vnoremap <silent> <Plug>UWikiMakeVRef :<c-u>call uwiki#ref#create_visual()<cr>
nnoremap <silent> <Plug>UWikiMakeOrGotoRef :call uwiki#ref#create_or_goto()<cr>

augroup uwiki
	au!

	" Dispatch to wiki-specific stuff, when we want to do wiki-local stuff
	au BufNewFile,BufFilePre,BufRead * if uwiki#get_root_dir() != ''
		\| 	doautocmd <nomodeline> User UWikiEnter
		\| endif

	" Bonus stuff
	au User UWikiEnter if uwiki#defaults
		\| 	nmap <buffer> <c-cr> <Plug>UWikiMakeOrGotoRef
		\| 	vmap <buffer> <c-cr> <Plug>UWikiMakeVRef
		\| 	call uwiki#syntax_highlight()
		\| endif

augroup END
