" vim: set foldmethod=marker:

if exists("g:vscode")
	finish " Config is incompatible
endif

let g:configdir = fnamemodify($MYVIMRC, ':p:h')
let g:freestanding = exists("g:freestanding") && g:freestanding

" Some hosted environment stuff
if !g:freestanding
	" This needs to be early I think
	let g:python3_host_prog = '/usr/bin/python3'
	set rtp+=/usr/share/vim/vimfiles
endif

" Plugins {{{1

command! -nargs=+ NXnoremap  nnoremap <args>|xnoremap <args>
command! -nargs=+ NXmap      nmap <args>|xmap <args>

if &loadplugins

let g:eunuch_no_maps = 1
let g:polyglot_disabled = ["latex"]

" System
let &packpath .= "," + g:configdir

" Neovim Native LSP {{{2

command! -nargs=0 LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients()) <bar> let g:lsp_enable = 0
command! -nargs=0 LspDebug lua vim.lsp.set_log_level(vim.log.levels.DEBUG)

" TODO add a timeout to these <2022-07-10>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent> H  <cmd>lua vim.lsp.buf.code_action()<cr>
xnoremap <silent> H  <cmd>lua vim.lsp.buf.range_code_action()<cr>

" TODO: Switch to using numhl when neovim v0.7 gets released <2022-03-18>
"       This is blocked on neovim/neovim#16914 'don't put empty sign text in line number column'
sign define DiagnosticSignError text=✕ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn  text=▲ texthl=DiagnosticSignWarn  linehl= numhl=
sign define DiagnosticSignInfo  text=◆ texthl=DiagnosticSignInfo  linehl= numhl=
sign define DiagnosticSignHint  text=🞶 texthl=DiagnosticSignHint  linehl= numhl=

let g:lsp_enable = 1

augroup vimrc_lsp
	au!
	" au ColorScheme *
	" 	\ hi DiagnosticsError
	" 	\ hi DiagnosticsVirtualText        ctermfg=yellow cterm=italic
	" 	\ | hi DiagnosticsSignError        ctermfg=white ctermbg=red
	" 	\ | hi DiagnosticsSignWarn         ctermfg=black ctermbg=yellow
	" 	\ | hi DiagnosticsSignInfo         ctermfg=green
	" 	\ | hi link DiagnosticsError       DiagnosticsVirtualText
	" 	\ | hi link DiagnosticsWarning     DiagnosticsVirtualText
	" 	\ | hi link DiagnosticsInformation DiagnosticsVirtualText
	" 	\ | hi link DiagnosticsHint        DiagnosticsVirtualText

	au CursorHold * silent lua vim.diagnostic.open_float(nil, { focusable = false })

	" au BufWritePre * silent! lua vim.lsp.buf.formatting_sync(nil, 1000)

augroup END

" Goyo {{{2

let g:goyo_width = 90

" Undotree {{{2

let g:undotree_RelativeTimestamp = 0

" rainbow {{{2

let g:rainbow_active = 0
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['none', 'lightyellow', 'lightred', 'lightmagenta'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'markdown': {
\			'parentheses_options': 'containedin=markdownCode contained',
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'haskell': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'],
\		},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody',
\		},
\		'perl': {
\			'syn_name_prefix': 'perlBlockFoldRainbow',
\		},
\		'stylus': {
\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
\		},
\		'css': 0,
\	}
\}

" vim-polyglot {{{2

let g:did_cpp_syntax_inits = 1

" vim-easy-align {{{2

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = {
\ 't': { 'pattern': '\t', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 1 },
\ }

" Dispatch {{{2

let g:dispatch_no_maps = 1

endif

" Options {{{1

" Misc {{{2

let g:pdf_out = "/tmp/document.pdf"

" Use Ag if possible
if executable("rg")
	let &grepprg = "rg --vimgrep"
	set grepformat=%f:%l:%c:%m
elseif executable("ag")
	let &grepprg = "ag --nogroup --nocolor --column $*"
	set grepformat=%f:%l:%c%m
endif

set diffopt+=algorithm:patience,indent-heuristic
set updatetime=1000
set shell=$SHELL

let g:man_hardwrap = 0

let loaded_netrwPlugin = 1 " Disable netrw

" User Interface {{{2

" Status line
set laststatus=2
set showmode
set showtabline=1

" Line buffer at top/bottom when scrolling
set scrolloff=5

" Wild menu!
set wildmenu
set wildmode=longest:full,full

" searching stuff
set hlsearch
set ignorecase
set smartcase
set incsearch

" replacing stuff
set inccommand=nosplit

" Don't redraw during macros
set lazyredraw

" No bells/flash
set noerrorbells
set novisualbell
set belloff=all

" Conceal
set conceallevel=1
set concealcursor=

" Hidden chars
set list listchars=tab:│\ ,extends:›,precedes:‹,nbsp:⎵,trail:∙
set fillchars=eob:\ ,vert:│,fold:─,stl:\ ,stlnc:\ ,diff:-,foldopen:╒,foldclose:═


" Line numbers
set number norelativenumber
set signcolumn=number " signs in number column

" Line wrapping, toggle bound to <space>ow
set nowrap
set linebreak
set breakindent
let &showbreak='↳ '

" Fold on triple brace
set foldmethod=indent

" Minimal folding initially
set foldlevelstart=99

" Don't open folds
set foldopen&
set foldclose&

" Make with tee
set shellpipe=2>&1\ \|\ tee

" hit-enter prompt
set shortmess=nxcIT

" Split options
set splitright
" set splitbelow

" % for angle brackets
set matchpairs+=<:>

" Show partial keypresses
set showcmd

" Colorscheme
colorscheme duality

" Tempfiles {{{2

" use default dirs
set swapfile
set undofile

" Editing {{{2

set nohidden " drop buffers after they're closed
set nofixeol " Don't want to keep updating eol in random files

" Mouse control
set mouse+=a

" Shell Options
set shellslash

" Completion
set completeopt=menu,menuone,noinsert,noselect
set complete=.,w,b,t

" Modeline
set modeline

" Timeout
set notimeout
set ttimeout
set ttimeoutlen=10

" Clipboard
set clipboard=unnamed,unnamedplus

" c-a and c-x
set nrformats=alpha,unsigned

" Automate
set autoread
set autowrite

" Key over lines
set backspace=2
set whichwrap+=<,>,[,]

" Spelling
set spelllang=en_au,en_gb
set spellsuggest=fast,8

" Viminfo
set viminfo=!,%,'64,/16,s10,c,f1,h,rD:,rE:

" Allow cursor to go anywhere in visual block mode
set virtualedit+=block

" Formatting {{{2

" Word formatting
set textwidth=0
set formatoptions=tcrqlnj
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

" Autocommands {{{1

augroup vimrc
	au!

	" for proper nesting
	au TermOpen * let $NVIM_LISTEN_ADDRESS=v:servername
	au TermOpen * setl nonumber norelativenumber

	" Cursorline if not active
	setg cursorline
	au BufEnter,FocusGained,WinEnter * set nocursorline
	au User GoyoEnter setg nocursorline
	au User GoyoLeave setg cursorline
	au BufLeave,FocusLost,WinLeave * set cursorline<

	" Non-breaking autochdir
	au BufWinEnter * if empty(&buftype) | silent! lcd %:p:h | endif

	au FocusLost,VimLeavePre *
		\ if ((&bt == '' && !empty(glob(bufname('%')))) || &bt == 'acwrite') && !&readonly
		\ | 	silent update
		\ | endif
	au VimResized * wincmd =

	au Syntax *
		\ syntax match ConflictMarker containedin=ALL /^\(<<<<<<<\|=======\||||||||\|>>>>>>>\).*/
		\ | hi def link ConflictMarker Error

	" Skeleton files
	au BufNewFile *
		\ for fname in glob(g:configdir . '/skeletons/{.,}*', v:false, v:true)
		\ | 	if expand('<afile>') =~# glob2regpat('*' . fnamemodify(fname, ':t'))
		\ | 		silent exec '0read' fname | silent $d | silent $
		\ | 		break
		\ | 	endif
		\ | endfor

	" PEP 350 Codetags (https://www.python.org/dev/peps/pep-0350/)
	au Syntax * syn keyword Codetags contained containedin=.*Comment.*
		\ TODO MILESTONE MLSTN DONE YAGNI TDB TOBEDONE
		\ FIXME XXX DEBUG BROKEN REFACTOR REFACT RFCTR OOPS SMELL NEEDSWORK INSPECT
		\ BUG BUGFIX
		\ NOBUG NOFIX WONTFIX DONTFIX NEVERFIX UNFIXABLE CANTFIX
		\ REQ REQUIREMENT STORY
		\ RFE FEETCH NYI FR FTRQ FTR
		\ IDEA
		\ QUESTION QUEST QSTN WTF
		\ ALERT
		\ HACK CLEVER MAGIC
		\ PORT PORTABILITY WKRD
		\ CAVEAT CAV CAVT WARNING CAUTION
		\ NOTE HELP
		\ FAQ
		\ GLOSS GLOSSARY
		\ SEE REF REFERENCE
		\ TODOC DOCDO DODOC NEEDSDOC EXPLAIN DOCUMENT
		\ CRED CREDIT THANKS
		\ STAT STATUS
		\ RVD REVIEWED REVIEW
		\ SAFETY
		\ | hi def link Codetags Todo

augroup END

" Bindings {{{1

" Commands {{{2

command! -nargs=0 W exec "w !pkexec tee %:p >/dev/null" | setl nomod
" This, for some reason, doesn't work if you put it in a function
command! -nargs=+ Keepview let s:view_save = winsaveview() | exec <q-args> | call winrestview(s:view_save)
command! -nargs=+ -complete=file Fork call jobstart(<q-args>)
command! -nargs=* -complete=lua LP lua print(vim.inspect(<args>))

" Multitools {{{2

lua << EOF
local luasnip = require "luasnip"
local cmp = require "cmp"

local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function interp(x)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(x, true, false, true), "n", false)
end

-- these can't be <expr> maps since inserting text is forbidden while evaluating the map

vim.keymap.set({ "i", "s" }, "<tab>", function()
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_locally_jumpable() then
		luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		interp("<Tab>")
	end
end)

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.in_snippet() and luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		interp("<Tab>")
	end
end)

vim.keymap.set({ "i", "s"}, "<cr>", function()
	if cmp.get_selected_entry() ~= nil then
		cmp.confirm()
	else
		interp("<cr>")
	end
end)

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if cmp.get_selected_entry() ~= nil then
		cmp.confirm()
		return
	end
	if cmp.visible() then
		cmp.close()
	end
	if luasnip.expand_or_locally_jumpable() then
		luasnip.expand_or_jump()
	end
end)

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if luasnip.in_snippet() and luasnip.jumpable(-1) then
		luasnip.jump(-1)
	end
end)

-- vim.keymap.set("i", "<space>", function()
-- 	if cmp.visible() then
-- 		cmp.confirm()
-- 	end
-- 	interp("<space>")
-- end)

EOF

map <expr> <return>
	\ (&buftype == "help" <bar><bar> expand("%:p") =~ "^man://") ? "\<c-]>"
	\ : &buftype == "quickfix" ? "\<CR>"
	\ : "@q"

" Misc {{{2

NXnoremap <left> zh
NXnoremap <right> zl
NXnoremap <up> <c-y>
NXnoremap <down> <c-e>

" better binds
noremap ; :
noremap , ;
noremap ' `
noremap <silent> <expr> 0 &wrap ? 'g0' : '0'
command! -nargs=0 -range=% KillWhitespace Keepview <line1>,<line2>s/[\x0d[:space:]]\+$//e | nohl
NXnoremap <expr> G &wrap ? "G$g0" : "G"
noremap <s-return> @w
nnoremap Y y$
nnoremap g= 1z=
nnoremap & <cmd>&&<cr>
xnoremap & <c-\><c-n><cmd>'<,'>&&<cr>
xnoremap p P

" surround operation
xmap s <Plug>(vsurround)

" listify
function! Listify(motion) " {{{
	if a:motion !=# "V"
		echoe "Cannot Listify outside of linewise-visual mode"
		return
	endif

	exec "normal! \<esc>"
	'<,'>s/$/,
	'<s/^\s*/\0[ /
	'>s/,$/ ]/
	'<,'>join
	normal! V
endfunction " }}}
xnoremap L <cmd>call Listify(mode())<cr>

" operatorfunc tester
nnoremap go <cmd>set operatorfunc=OperatorFuncTest<cr>g@

" find/replace tools
nnoremap # <cmd>let @/ = '\V\C\<' . escape(expand('<cword>'), '\') . '\>' <bar> set hls<cr>

" Fixed I/A for visual
xnoremap <expr> I mode() ==# 'v' ? "\<c-v>I" : mode() ==# 'V' ? "\<c-v>^o^I" : "I"
xnoremap <expr> A mode() ==# 'v' ? "\<c-v>A" : mode() ==# 'V' ? "\<c-v>Oo$A" : "A"

" Folding
nnoremap <tab> za

" Since ^I == <tab>, we replace ^I with ^P
noremap <c-p> <c-i>

" Clear highlight
nnoremap <silent> <esc> <cmd>nohl<cr>

" Logical lines
noremap <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <expr> $ &wrap ? "g$" : "$"

" Keep visual
xnoremap < <gv
xnoremap > >gv

" Select pasted text
" TODO this doesn't work when pasting from non-default registers
nnoremap <expr> gp "`[" . getregtype()[0] . "`]"

" Register-preserving delete
NXmap X "_d
nmap XX "_dd
nnoremap x "_x

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
inoremap <c-a> <c-o>^
cnoremap <c-a> <Home>
cnoremap <c-k> <c-\>egetcmdline()[:getcmdpos()-2]<cr>

" Terminal {{{2

" escape as normal
tnoremap <esc> <c-\><c-n>

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
nnoremap <leader> <nop>
nnoremap <leader>x <cmd>call v:lua.exec_current()<cr>
nnoremap <leader>m <cmd>Dispatch<cr>

" misc
nnoremap <silent> <leader>r <cmd>mode <bar> syntax sync fromstart<cr>

nnoremap <silent> <leader>P <cmd>belowright vertical new<cr><c-w>W80<c-w><bar><cmd>set wfw<cr>
nnoremap <expr><silent> <leader>p (v:count == 0 ? '80' : '') . "<c-w><bar>"

" toggles
nnoremap <leader>o <nop>
nnoremap <silent> <leader>ow <cmd>set wrap! <bar> set wrap?<cr>
nnoremap <silent> <leader>ou <cmd>UndotreeToggle<cr><c-w>999h
nnoremap <silent> <leader>os <cmd>set spell! <bar> set spell?<cr>
nnoremap <silent> <leader>og <cmd>Goyo<cr>ze
nnoremap <silent> <leader>on <cmd>set relativenumber! <bar> set relativenumber?<cr>
nnoremap <silent><expr> <leader>oc getqflist({"winid":0}).winid ? "<cmd>cclose<cr>" : "<cmd>botright copen<cr>"
nnoremap <silent><expr> <leader>ol getloclist(0, {"winid":0}).winid ? "<cmd>botright lclose<cr>" : "<cmd>botright lopen<cr>"
nnoremap <silent><expr> <leader>oL getqflist({"winid":0}).winid ? "<cmd>cclose<cr>" : "<cmd>lua require'vimrc.diagnostic'.load_qf()<cr><cmd>botright copen<cr>"
nnoremap <expr> <silent> <leader>od (&diff ? '<cmd>diffoff' : '<cmd>diffthis') . ' <bar> set diff?<cr>'

" file ctl
nnoremap <leader>w <cmd>up<cr>
nnoremap <leader>q <cmd>q<cr>

nnoremap <leader>ev <cmd>e $MYVIMRC<cr>
nnoremap <leader>el <cmd>exec "e" g:configdir . "/init2.lua"<cr>
nnoremap <leader>ee <cmd>call OpenCorresponding()<cr>

" cleanup
nnoremap <silent> <leader>k <nop>
nnoremap <silent> <leader>kw :KillWhitespace<cr>

" Splits
nnoremap <leader>s <nop>
nnoremap <silent> <leader>ss <c-w>s
nnoremap <silent> <leader>sv <c-w>v
nnoremap <silent> <leader>sh :aboveleft vertical new<cr>
nnoremap <silent> <leader>sk :aboveleft new<cr>
nnoremap <silent> <leader>sj :belowright new<cr>
nnoremap <silent> <leader>sl :belowright vertical new<cr>
nnoremap <leader>t :tab new<cr>

" Other Features {{{1

augroup vimrc_ssh
	au!

	" au BufReadCmd ssh://*
	" 	\   exe "silent doau BufReadPre" fnameescape(expand("<amatch>"))
	" 	\ | echo "TODO"
	" 	\ | exe "silent doau BufReadPost" fnameescape(expand("<amatch>"))
    "
	" au FileReadCmd ssh://*
	" 	\   exe "silent doau FileReadPre" fnameescape(expand("<amatch>"))
	" 	\ | echo "TODO"
	" 	\ | exe "silent doau FileReadPost" fnameescape(expand("<amatch>"))
    "
	" au BufWriteCmd ssh://*
	" 	\   exe "silent doau BufWritePre" fnameescape(expand("<amatch>"))
	" 	\ | echo "TODO"
	" 	\ | exe "silent doau BufWritePost" fnameescape(expand("<amatch>"))
    "
	" au FileWriteCmd ssh://*
	" 	\   exe "silent doau FileWritePre" fnameescape(expand("<amatch>"))
	" 	\ | echo "TODO"
	" 	\ | exe "silent doau FileWritePost" fnameescape(expand("<amatch>"))
    "
	" au SourceCmd ssh://*
	" 	\   exe "silent doau FileWritePre" fnameescape(expand("<amatch>"))
	" 	\ | echo "TODO"
	" 	\ | exe "silent doau FileWritePost" fnameescape(expand("<amatch>"))

augroup END

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

exec "doau <nomodeline> ColorScheme" g:colors_name

exec "source" g:configdir . "/init2.lua"

" Stop plugins from pollution leader
let mapleader = "\\"
