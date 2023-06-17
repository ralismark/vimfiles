let g:freestanding = exists("g:freestanding") && g:freestanding

" Some hosted environment stuff
if !g:freestanding
	" This needs to be early I think
	let g:python3_host_prog = exepath("python3")
	set rtp+=/usr/share/vim/vimfiles
endif
