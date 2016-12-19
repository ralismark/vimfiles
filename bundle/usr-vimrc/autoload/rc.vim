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

fun! rc#artificial_make(full_cmd)
	doautocmd QuickFixCmdPre make

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
			let matches[i] = matches[pre_num_len:]
		endfor

		" TODO(timmy): finish
	endif
endfun

fun! rc#make() " {{{2
	call rc#make_arg_prep()
	let args = g:rc#make_mappings[g:make_mode][1]()

	exec 'make! ' . args . ' ' . g:make_args
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

fun! rc#complete(findstart, base) " {{{2
	if a:findstart == 1
		return rc#compl_match()
	else
		let line = getline('.')[ : -len(getline('.')) + col('.') - 2]

		" include matching
		if match(line, '^\s*#\s*include') > -1
			let out = []
			if match(line, '^\s*#\s*include\s*"') > -1

				let out = GetLocalIncludes(a:base)

			elseif match(line, '^\s*#\s*include\s*<') > -1
				let words = Find(a:base . '*', $include)

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
		endif
	endif
endfun

fun! rc#compl_match() " {{{2
	let line = getline('.')[ : -len(getline('.')) + col('.') - 2]
	let lastchar = match(line[len(line) - 1], '\S\s*$')

	let loc = match(line, '^\s*#\s*include\s*["<]\s*\zs')
	if loc > -1
		return loc
	endif

	if match(line[lastchar], '[{}[]()|&<>;]') > -1
		" no match, is symbol
		" return lastchar
	endif

	return -3
endfun
