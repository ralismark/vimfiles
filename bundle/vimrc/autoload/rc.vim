" vimrc supplementing file

fun! rc#get_include_pathlist() " {{{2
	if exists('s:ipathlist')
		return s:ipathlist
	endif

	let s:ipathlist = ""

	if has('unix') " running linux or similar
		" TODO: generalise to other compilers - use env CXX? make?
		let lang_opt = &ft =~ 'cpp' ? '-xc++' : '-xc'
		let raw_ipath = system('echo | gcc ' . lang_opt .  ' -v -E - 2>&1 | sed -e ''1,/#include </d'' -e ''/^End of search list\./,$d''')
		let pathlist = map(split(raw_ipath, '\n'), {k,v -> substitute(v, '^[[:space:]]*', '', '')})
		let s:ipathlist = join(pathlist, ',')
	elseif has('win32') " windows
		let path = substitute(substitute($INCLUDE, ';', ',', 'g'), '\', '/', 'g')
		let s:ipathlist = path
	endif
	return s:ipathlist
endfun

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
		let words = rc#find_in_path_list(a:base . '*', rc#get_include_pathlist())

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

fun! rc#find_in_path_list(file, pathlist) " {{{2
	let raw_matches = globpath(a:pathlist, a:file, 0, 1)
	let results = map(raw_matches, {k,v -> substitute(v, '\', '/', 'g') . (isdirectory(v) ? '/' : '')})

	for item in range(len(results))
		for pathitem in split(a:pathlist, ',')
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
