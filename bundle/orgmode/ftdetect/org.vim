" Vim Filetype Detection
" Language: Org Mode
" Maintainer: Timmy Yao
" Latest Revision: 23 November 2017

augroup orgmode
	au!

	au BufNewFile,BufRead *.org set filetype=org

	" hack to add todo items
	au FileType org let &l:comments = 'b:#,b::,'
	\ . 'sb:- [x],sb:- [X],sb:- [-],sb:- [ ],mb:- [ ],b:-,'
	\ . 'sb:+ [x],sb:+ [X],sb:+ [-],sb:+ [ ],mb:+ [ ],b:+'

augroup END
