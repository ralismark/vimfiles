function! TabLineLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let bufname = expand("#" . buflist[winnr - 1] . ":t")
	return bufname == "" ? "-" : bufname
endfunction

function! TabLine()
	let s = ""

	for i in range(1, tabpagenr("$"))
		let s .= i == 1 ? "" : " "

		let mode = i == tabpagenr() ? "Sel" : "Tab"

		let s .= "%#TabLine".mode."I#%#TabLine".mode."#%".i."T "
		let s .= "" . i . ". " . "%{TabLineLabel(" . i . ")}" " Actual label
		let s .= " %0T%#TabLine".mode."I#%#TabLineFill#"
	endfor

	let s = "%=" . s . "%#TabLineFill#%="

	" let s = getcwd() . " " . s

	let n_errs = luaeval("#vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })")
	let n_warn = luaeval("#vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARNING })") - n_errs
	if n_errs != 0 || n_warn != 0
		let s .= "" . (n_errs ? " E:" . n_errs : "") . (n_warn ? " W:" . n_warn : "") . " "
	endif
	return s
endfunction

augroup vimrc_tabline
	au!
	au ColorScheme *
	\   hi TabLineFill  ctermfg=red             ctermbg=234             cterm=NONE
	\ | hi TabLineTab   ctermfg=white           ctermbg=237             cterm=NONE
	\ | hi TabLineTabI  ctermfg=237             ctermbg=234             cterm=NONE
	\ | hi TabLineTabF  ctermfg=grey            ctermbg=237             cterm=NONE
	\ | hi TabLineSel   ctermfg=black           ctermbg=white           cterm=NONE
	\ | hi TabLineSelI  ctermfg=white           ctermbg=234             cterm=NONE
	\ | hi TabLineSelF  ctermfg=grey            ctermbg=white           cterm=NONE
augroup END

set tabline=%!TabLine()
