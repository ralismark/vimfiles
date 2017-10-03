" vimrc supplementing file

" make commands {{{1

fun! rc#make_command(args) " {{{2
	let cmd = '[' . &makeprg . ']'
	let cmd = substitute(cmd, '\$\*',      {m -> a:args},       ' ')
	let cmd = substitute(cmd, '%',         {m -> expand(m[0])}, ' ')
	let cmd = substitute(cmd, '#<[0-9]\+', {m -> expand(m[0])}, ' ')
	let cmd = substitute(cmd, '#',         {m -> expand(m[0])}, ' ')
	let cmd = substitute(cmd, '##',        {m -> expand(m[0])}, ' ')
	let cmd = substitute(cmd, '#[0-9]\+',  {m -> expand(m[0])}, ' ')
	return cmd[1:-2]
endfun

" rc#make_mappings {{{2
let rc#make_mappings = {
	\ 'exe': [ 'compile',           { -> rc#make_command('-o ' . expand('%:r') . '.exe') }],
	\ 'syn': [ 'syntax check only', { -> rc#make_command('-fsyntax-only') }],
	\ }

fun! rc#make_arg_prep() " {{{2
	if !exists('g:make_args')
		let g:make_args = ''
	endif
	if !exists('g:make_mode')
		let g:make_mode = keys(g:rc#make_mappings)[0]
	endif
endfun

fun! rc#artificial_make(full_cmd, jump_to_first, ...)
	if has('autocmd')
		silent! doautocmd QuickFixCmdPre make
	endif

	let cmd_shortened = a:0 >= 3 ? a:3 : a:full_cmd

	if &autowrite || &autowriteall
		silent! wall
	endif

	let errorfile = &makeef
	if errorfile == ''
		let errorfile = tempname()
	elseif errorfile !~ '##'
		if !empty(glob(errorfile))
			if delete(errorfile) == -1
				echoerr "could not delete makeef"
			endif
		endif
	else
		let glob = substitute(errorfile, '##', '*')
		let re = substitute(errorfile, '##', '\d\+')
		let pre_num_len = match(errorfile, '##')

		let matches = filter(glob(glob, v:false, v:true), { k, v -> match(v, re) >= 0 })

		for i in range(len(matches))
			let matches[i] = +matches[pre_num_len:]
		endfor

		" now we have a list of numbers

		let num = max(matches) + 1

		let errorfile = substitute(errorfile, '##', num)
	endif

	let makecmd = a:full_cmd . ' ' . &shellpipe . ' ' . errorfile

	let start_time = localtime()
	let errorcode = system(makecmd)
	let end_time = localtime()

	let contents = readfile(errorfile)
	let post_info = '[finished in ' . (end_time - start_time) . ' sec'
		\ . (errorcode == 0 ? '' : '; returned ' . errorcode) . ']'
	call writefile(['[' . cmd_shortened . ']'] + contents + [post_info], errorfile)

	exe (a:jump_to_first ? 'cfile' : 'cgetfile') errorfile

	if has('autocmd')
		silent! doautocmd QuickFixCmdPost make
	endif

	call delete(errorfile)
endfun

fun! rc#make() " {{{2
	call rc#make_arg_prep()
	let args = g:rc#make_mappings[g:make_mode][1]()

	call rc#artificial_make(args . ' ' . g:make_args, v:false)
endfun

fun! rc#make_mode_switch() " {{{2
	call rc#make_arg_prep()

	let keys = keys(g:rc#make_mappings)

	let idx = index(keys, g:make_mode)
	if idx == 0
		let idx = len(keys)
	endif
	let idx = idx - 1

	let g:make_mode = keys[idx]

	echo '\m -> ' . g:rc#make_mappings[keys[idx]][0]
endfun

" completion {{{1

fun! rc#get_local_includes(base) " {{{2
	let out = []

	let words = glob(a:base . '*', 0, 1)
	let files = filter(copy(words), { key, val -> !isdirectory(val) })
	let dirs = filter(copy(words), { key, val -> isdirectory(val) })

	if a:base =~ '^\(\.\.[\\/]\)*$'
		call insert(dirs, a:base . '..')
	endif

	for i in range(len(files))
		let out += [ {
		\ 'word': files[i],
		\ 'abbr': files[i],
		\ 'menu': 'f'
		\ } ]
	endfor

	for i in range(len(dirs))
		let out += [ {
		\ 'word': dirs[i],
		\ 'abbr': dirs[i] . '/',
		\ 'menu': 'd'
		\ } ]
	endfor

	return out
endfun

fun! rc#complete_include(line, base) " {{{2
	let out = []
	if match(a:line, '^\s*#\s*include\s*"') > -1
		let out = rc#get_local_includes(a:base)
	elseif match(a:line, '^\s*#\s*include\s*<') > -1
		let words = rc#find_in_path_list(a:base . '*', $include)

		for i in range(len(words))
			if words[i][-1:-1] == '/'
				let out += [ {
				\ 'word': words[i][:-2],
				\ 'abbr': words[i],
				\ 'menu': 'd'
				\ } ]
			else
				let out += [ {
				\ 'word': words[i],
				\ 'abbr': words[i],
				\ 'menu': 'f'
				\ } ]
			endif
		endfor
	endif

	return { 'words': out, 'refresh': 'always' }
endfun

fun! rc#find_in_path_list(file, path) " {{{2
	let path = substitute(substitute(a:path, ';', ',','g'), '\', '/', 'g')
	let pathlist = split(path, ',')

	let pathexpr = '\V\^\(\(' . join(pathlist, '\)\|\(') . '\)\)/\?'
	let results = map(map(globpath(path, a:file, 0, 1), 'v:val . (isdirectory(v:val) ? "/" : "")'), 'substitute(v:val, "\\", "/", "g")')

	for item in range(len(results))
		for pathitem in pathlist
			if results[item] =~ ('\V\^' . pathitem)
				let results[item] = results[item][len(pathitem)+1:]
				break
			endif
		endfor
	endfor

	return results
endfun

fun! rc#complete(findstart, base) " {{{2
	" line up to the cursor
	let line = getline('.')[:-len(getline('.')) + col('.') - 2]
	let visible = a:findstart ? line : a:base

	" offset of last character
	let lastchar = match(line[len(line) - 1], '.*$')

	let include_loc = match(line, '^\s*#\s*include\s*["<]\s*\zs')
	if include_loc > -1
		if a:findstart == 1
			return include_loc
		else
			return rc#complete_include(line, a:base)
		endif
	endif

	if a:findstart == 1
		return -3
	endif
endfun
