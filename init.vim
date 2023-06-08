" vim: set foldmethod=marker foldlevel=0:

if exists("g:vscode")
	finish " Config is incompatible
endif

let g:configdir = fnamemodify($MYVIMRC, ':p:h')
let g:freestanding = exists("g:freestanding") && g:freestanding

" let &packpath .= "," .. g:configdir

" Some hosted environment stuff
if !g:freestanding
	" This needs to be early I think
	let g:python3_host_prog = exepath("python3")
	set rtp+=/usr/share/vim/vimfiles
endif

" Options {{{1

" Misc {{{2

let g:pdf_out = "/tmp/document.pdf"

" Editing {{{2

" Completion
set completeopt=menu,menuone,noinsert,noselect
set complete=.,w,b,t

" Clipboard
set clipboard=unnamed,unnamedplus

" Formatting {{{2

" Word formatting
set textwidth=0
set formatoptions=tcro/qlnj
set nojoinspaces

" kernel style indents
set tabstop=4
set shiftwidth=0
set noexpandtab
set smarttab

set autoindent
set copyindent
set preserveindent

" vim continuation indent
let g:vim_indent_cont = 0

" c indent
set cino=
set cino+=(s  " Contents of unclosed parentheses
set cino+=:0  " Case labels
set cino+=Ls  " Jump labels
set cino+=u0
set cino+=U0  " Do not ignore when parens are first char in line
set cino+=b0  " Align break with case
set cino+=g0  " Scope labels
set cino+=l1  " No align with label
set cino+=t0  " Function return type declarations

" Functions {{{1

lua << EOF
function exec_current() -- {{{2
	for ft in string.gmatch(vim.bo.ft, "[^.]+") do
		local com = execprg[ft]
		if com ~= nil and com ~= vim.NIL then
			com()
			return
		end
	end

	vim.api.nvim_echo({
		{ "No execprg found for ft='" .. vim.bo.ft .. "'", "ErrorMsg" }
	}, false, {})
end
EOF

function! TabLineLabel(n) " {{{2
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let bufname = expand("#" . buflist[winnr - 1] . ":t")
	return bufname == "" ? "-" : bufname
endfunction

function! TabLine() " {{{2
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

function! GetSynClass() " {{{2
	return map(synstack(line('.'), col('.')), {k,v -> synIDattr(v, "name")})
endfunction

function! OperatorFuncTest(motion) " {{{2
	if a:motion ==# "line"
		normal! `[V`]
	elseif a:motion ==# "char"
		normal! `[v`]
	elseif a:motion ==# "block"
		exec "normal! `[\<c-v>`]"
	endif
endfunction

function! OpenCorresponding() " {{{2
	let candidate_exts = get(g:corresmap, expand("%:e"), [])
	for ext in candidate_exts
		let candidate = expand("%:r") . "." . ext
		if filereadable(candidate)
			exec "edit" candidate
			return
		endif
	endfor
	echoe "No corresponding file found! looked for: " . join(candidate_exts, ", ")
endfunction
let g:corresmap = {
\ "h": ["c", "cpp"],
\ "hpp": ["c", "cpp"],
\ "c": ["h", "hpp"],
\ "cpp": ["h", "hpp"],
\ }

" Bindings {{{1

" Commands {{{2

command! -nargs=0 W exec "w !pkexec tee %:p >/dev/null" | setl nomod
" This, for some reason, doesn't work if you put it in a function
command! -nargs=+ Keepview let s:view_save = winsaveview() | exec <q-args> | call winrestview(s:view_save)
command! -nargs=+ -complete=file Fork call jobstart(<q-args>)
command! -nargs=* -complete=lua LP lua print(vim.inspect(<args>))

" Misc {{{2

" better binds
command! -nargs=0 -range=% KillWhitespace Keepview <line1>,<line2>s/[\x0d[:space:]]\+$//e | nohl
noremap <s-return> @w
nnoremap g= 1z=

" Select pasted text
nnoremap <expr> gp '`[' . getregtype()[0] . '`]'

" operatorfunc tester
nnoremap go <cmd>set operatorfunc=OperatorFuncTest<cr>g@

" find/replace tools
nnoremap # <cmd>let @/ = '\V\C\<' . escape(expand('<cword>'), '\') . '\>' <bar> set hls<cr>

" Folding
nnoremap <tab> za

" Since ^I == <tab>, we replace ^I with ^P
noremap <c-p> <c-i>

" Clear highlight
nnoremap <silent> <esc> <cmd>nohl<cr>

" Select pasted text
" TODO this doesn't work when pasting from non-default registers
nnoremap <expr> gp "`[" . getregtype()[0] . "`]"

nnoremap <c-f> "xyy
xnoremap <c-f> "xy
inoremap <c-f> <cmd>lua require("luasnip.extras.otf").on_the_fly("x")<cr>

" Insert mode {{{2

" Insert ISO 8601 date
noremap! <c-r><c-d> <c-r>=strftime("%Y-%m-%d")<cr>

inoremap <c-r><c-r> <c-r>"
cnoremap <c-r><c-r> <c-r>"
snoremap <c-r><c-r> <c-r>"

inoremap <c-e> <c-o><c-e>
inoremap <c-y> <c-o><c-y>

" readline binds
cnoremap <c-k> <c-\>egetcmdline()[:getcmdpos()-2]<cr>

" Buffer/window/tab {{{2

" Buffer/Tab switching
nnoremap <silent> [b <cmd>bprev<cr>
nnoremap <silent> ]b <cmd>bnext<cr>
nnoremap <silent> [t <cmd>tabprev<cr>
nnoremap <silent> ]t <cmd>tabnext<cr>
nnoremap <silent> [T <cmd>tabmove -1<cr>
nnoremap <silent> ]T <cmd>tabmove +1<cr>

" quickfix browse
nnoremap <silent> [c <cmd>cprev<cr>
nnoremap <silent> ]c <cmd>cnext<cr>
nnoremap <silent> [l <cmd>lprev<cr>
nnoremap <silent> ]l <cmd>lnext<cr>
nnoremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<cr>

" Buffer ctl
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Leaders " {{{2

let mapleader = "\<Space>"

" more leaders
nnoremap <leader>x <cmd>call v:lua.exec_current()<cr>
nnoremap <leader>m <cmd>Dispatch<cr>

" misc

nnoremap <silent> <leader>P <cmd>belowright vertical new<cr><c-w>W80<c-w><bar><cmd>set wfw<cr>
nnoremap <expr><silent> <leader>p (v:count == 0 ? '80' : '') . "<c-w><bar>"

" toggles
nnoremap <silent><expr> <leader>oL getqflist({"winid":0}).winid ? "<cmd>cclose<cr>" : "<cmd>lua require'vimrc.diagnostic'.load_qf()<cr><cmd>botright copen<cr>"

" file ctl
nnoremap <leader>w <cmd>up<cr>
nnoremap <leader>q <cmd>q<cr>

nnoremap <leader>ev <cmd>e $MYVIMRC<cr>
nnoremap <leader>el <cmd>exec "e" g:configdir . "/init2.lua"<cr>
nnoremap <leader>ee <cmd>call OpenCorresponding()<cr>

" cleanup
nnoremap <silent> <leader>k <nop>
nnoremap <silent> <leader>kw :KillWhitespace<cr>

" Other Features {{{1

lua << EOF
local function open_pdf_out()
	if vim.g.pdf_out == nil then
		error("g:pdf_out is not defined")
	end
	vim.fn.jobstart({ "xdg-open", vim.g.pdf_out })
end

execprg = {
	vim = function()
		vim.cmd("source %")
	end,
	lua = function()
		local mod = require "vimrc.reload".module_from_path(vim.fn.expand("%:p"))
		if mod ~= nil then
			print("Reloading " .. mod)
			require "plenary.reload".reload_module(mod, false)
			require(mod)
		else
			vim.cmd("luafile %")
		end
	end,

	html = function()
		local path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "firefox", "--new-window", "file://" .. path })
	end,
	tex = function()
		local stem = vim.fn.expand("%:r")
		vim.fn.jobstart({ "xdg-open", stem .. ".pdf" })
	end,
	java = function()
		vim.cmd("botright split")
		vim.fn.termopen({"java", vim.fn.expand("%")})
	end,

	rmd = open_pdf_out,
	pandoc = open_pdf_out,
	dot = open_pdf_out,
	mermaid = open_pdf_out,
}
EOF

exec "source" g:configdir . "/init2.lua"
