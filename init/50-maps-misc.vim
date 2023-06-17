" Commands {{{1

command! -nargs=0 W exec "w !pkexec tee %:p >/dev/null" | setl nomod
" This, for some reason, doesn't work if you put it in a function
command! -nargs=+ Keepview let s:view_save = winsaveview() | exec <q-args> | call winrestview(s:view_save)

" Misc {{{1

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

" Insert mode {{{1

" Insert ISO 8601 date
noremap! <c-r><c-d> <c-r>=strftime("%Y-%m-%d")<cr>

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

" Leaders " {{{1

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
nnoremap <leader>ee <cmd>call OpenCorresponding()<cr>

" cleanup
nnoremap <silent> <leader>k <nop>
nnoremap <silent> <leader>kw :KillWhitespace<cr>

