" Misc {{{1

" blackhole register
noremap <bs> "_

" Select pasted text
nnoremap <expr> gp '`[' . getregtype()[0] . '`]'

" operatorfunc tester
function! OperatorFuncTest(motion)
	if a:motion ==# "line"
		normal! `[V`]
	elseif a:motion ==# "char"
		normal! `[v`]
	elseif a:motion ==# "block"
		exec "normal! `[\<c-v>`]"
	endif
endfunction
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

" Insert mode {{{1

inoremap <c-r><c-r> <c-r>"
cnoremap <c-r><c-r> <c-r>"
snoremap <c-r><c-r> <c-r>"

inoremap <c-e> <c-o><c-e>
inoremap <c-y> <c-o><c-y>

" readline binds
cnoremap <c-k> <c-\>egetcmdline()[:getcmdpos()-2]<cr>

" Buffer/window/tab {{{1

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
