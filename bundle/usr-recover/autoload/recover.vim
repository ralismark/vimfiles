function! recover#swapexists()
	echo 'ffffff'
endfunction!

function! recover#get_swap_msg(fullpath)
	let tempfile = tempname()

	" command to run when opening (w/ swap detected)
	"   set noswf - don't create an extra swap file
	" typed literally:
	"   o         - open readonly
	"   \n        - close message
	"   \e        - escape to normal mode
	"   :qa!\n    - quit
	"   \n        - close message
	let vimcmd = '-c "set noswf | call feedkeys(''o\n\e:qa!\n'')"'
	let cmd = printf('"%s" -i NONE -u NONE -es -V0%s %s %s',
		\ v:progpath,
		\ fnamemodify(tname, ':p:8')
		\ vimcmd
		\ fnamemodify(a:fullpath, ':p:8'))
	call vimproc#system(cmd)

	let msg = readfile(tempfile)
	call delete(tempfile)

	" remove extra bits not related to message
	" e.g. info about recovering and what to do
	let msg_end = match(msg, '^$', 2) " first line is blank, second blank is end of paragraph
	return msg[0 : msg_end - 1]
endfunction
