" A better response to recover prompts
" Author: Timmy Yao
" Version: 0.1.0
" Last Modified: 29 December 2017
"
" This plugin provides an automatic response to swapexists prompts, deleting
" it or showing a diff.

function! recover#swapexists()
	" check if it's because the file is open
	let handled = recover#check_loaded(expand('%'))
	if !empty(handled)
		let v:swapchoice = handled
		return
	endif

	" Old Swapfile - kill it
	if getftime(v:swapname) < getftime(expand('%'))
		call delete(v:swapname)
		call confirm("Swapfile older than on-disk file - deleting it")
		let v:swapchoice = 'e'
		return
	endif

	" Actual swapexists
	" check difference between recovered file and original file
	" if same, delete swap
	let v:swapchoice = 'r'
	augroup swap_response
		au BufWinEnter * call recover#swapcheck()
		au BufWinEnter * augroup swap_response | autocmd! | augroup END
	augroup END

	let b:swapname = v:swapname
endfunction!

" check recovered and original
function! recover#swapcheck()
	recover
	let recov_buf = bufnr('%')
	let recov_len = line('$')
	" Similar to :DiffOrig
	new
	set bt=nofile
	r ++edit #
	0d_
	exe 'file' fnameescape(expand('#') . ' (on-disk pre-recovery)')
	let orig_buf = bufnr('%')
	let orig_len = line('$')
	wincmd p " go back to orig

	let diff = 0

	" check the files
	if recov_len != orig_len
		let diff = 1
	endif
	for line in range(1, orig_len + 1)
		if diff
			break
		endif
		let diff = getbufline(orig_buf, line) !=# getbufline(orig_buf, line)
	endfor

	if diff
		call confirm("Recovered file differs from on-disk original! See open buffers", '', 1, 'E')
	else
		call confirm("No difference between on-disk and recovered - swap deleted")
		" delete extra buffer
		exec 'bdelete!' orig_buf
		call delete(b:swapname)
	endif
endfunction

" checks if the file is already loaded (in another instance)
function! recover#check_loaded(filename)
	let fname_esc = substitute(a:filename, "'", "''", "g")

	" Normal vim returns a newline-separated list, while neovim returns an
	" actual list
	let servers = has('nvim') ? serverlist() : split(serverlist(), "\n")
	for server in servers
		" Skip ourselves.
		if server ==? v:servername
			continue
		endif

		" Check if this server is editing our file.
		if remote_expr(server, "bufloaded('" . fname_esc . "')")
			" Tell the user what is happening.
			call confirm("File is being edited by " . server, '', 1, 'E')
			return 'q'
		endif
	endfor
	return ''
endfunction
