set nocompatible
autocmd!
abclear

let false = 0
let true = !false

let gui = has('gui_running') ? true : false
let con = !gui

  " Plugins {{{1 --------------------------------------------------------------

if &loadplugins

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
Helptags

let g:cpp_class_scope_highlight = true

" Syntastic {{{2

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_c_clang_check_args = "-std=c11 -fms-compatibility-version=19"
let g:syntastic_c_clang_check_post_args = "-Wall -Wextra -pedantic -O2 -D_CRT_SECURE_NO_WARNINGS"

let g:syntastic_cpp_clang_check_args = "-std=c++14  -fms-compatibility-version=19"
let g:syntastic_cpp_clang_check_post_args = "-Wall -Wextra -pedantic -O2 -D_CRT_SECURE_NO_WARNINGS"

" Unite {{{2

call unite#filters#matcher_default#use(['matcher_fuzzy'])

" Using ag as recursive command.
let g:unite_source_rec_async_command =
\ ['ag', '--follow', '--nocolor', '--nogroup',
\  '--hidden', '-g', '']

call unite#custom#profile('def', 'context', {
\	'no_split': true,
\	'prompt': "> ",
\	'prompt_direction': "top",
\	'start_insert': true,
\	'here': true,
\ })

au Filetype unite call s:unite_settings()
function! s:unite_settings()
	imap <buffer> <esc> <Plug>(unite_exit)
endfunction

" vimproc {{{2

let g:vimproc#download_windows_dll = true

" vim-easy-align {{{2 ---------------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Lightline {{{2 --------------------------------------------------------------

if con == true
	set showtabline=2
endif

set laststatus=2
set noshowmode

let g:lightline = {
\	'mode_map': {
\		'?': 'unk',
\
\		'n': 'nor',
\		'i': 'ins',
\		'R': 'rep',
\		'c': 'cmd',
\
\		'v': 'vis',
\		'V': 'vln',
\		"\<c-v>": 'vbk',
\
\		's': 'sel',
\		'S': 'sln',
\		"\<c-s>": 'sbk',
\	},
\	'component': {
\		'paste': '%{&paste ? "cp" : ""}',
\		'rostate': '%{(&modified ? "' . (gui ? '±' : '∓'). '" : &modifiable ? "w" : "r") . (&readonly ? "!" : "")}',
\		'filename': '%n# %{winwidth(0) > 65 ? PartPath() : (len(expand("%")) > 0 ? expand("%") : "*")}',
\
\		'filetype': '%{winwidth(0) <= 40 ? "" : &ft == "" ? "*" : &ft}',
\		'eoltype': '%{&ff == "dos" ? "" : &ff == "unix" ? "\\n" : "\\r"}',
\
\		'spell': '%{&spell ? (winwidth(0) > 70 ? "s:" . &spelllang : winwidth(0) > 50 ? "s..." : "") : ""}',
\
\		'location': '%{winwidth(0) > 50 ? printf("%s %03d:%-2d", LocPercent(), line("."), col(".")) : printf("%03d", line("."))}',
\	},
\	'component_visible_condition': {
\		'filetype': '(winwidth(0) > 40)',
\		'eoltype': '(&ff != "dos")',
\		'spell': '(&spell && winwidth(0) > 50)',
\	},
\	'active': {
\		'left': [ [ 'mode' ],
\			  [ 'filename', 'rostate' ],
\			  [ 'spell' ], ],
\		'right': [ [ 'location' ],
\			   [ 'filetype', 'eoltype' ] ],
\	},
\	'inactive': {
\		'left': [
\				[ 'filename', 'rostate' ],
\				[ 'fileencoding', 'eoltype' ],
\			],
\		'right': [
\				[ 'lineinfo' ],
\			],
\	},
\	'colorscheme': gui ? 'powerline' : 'cs',
\	'separator': gui ? { 'left': '', 'right': '' } : { 'left': '▓▒░', 'right': '░▒▓' },
\	'subseparator': gui ? {'left': '|', 'right': '|' } : { 'left': '░', 'right': '░' },
\ }

function! PartPath() " {{{2
	let parts = (['', '', ''] + split(expand('%:p:h'), '\'))[-3:]
	let fname = strlen(expand('%')) ? expand('%:t') : '*'

	let str = printf('%3.3S/%3.3S/%3.3S', parts[0], parts[1], parts[2])

	return str . ' / ' . fname
endfunction

function! LocPercent() " {{{2
	let cur = line('.')
	let top = 1
	let bot = line('$')

	if line('w$') == bot
		return "bot"
	elseif line('w0') == top
		return "top"
	else
		let prog = cur * 100 / bot
		return printf('%02d%%', prog)
	endif
endfunction

" DelimitMate {{{2 ------------------------------------------------------------

let delimitMate_expand_cr = true
let delimitMateBalance = true

" ConqueTerm {{{2 -------------------------------------------------------------

let g:ConqueTerm_EscKey = '<c-space>'

" Table Mode {{{2 -------------------------------------------------------------

let g:table_mode_map_prefix = 'gt'
let g:table_mode_toggle_map = 't'

" Startify {{{2 ---------------------------------------------------------------

let g:startify_session_dir = '~/vimfiles/session'
let g:startify_list_order = ['sessions', 'bookmarks', 'commands', 'files']
if getcwd() != $home
	call add(g:startify_list_order, 'dir')
endif
let g:startify_bookmarks = [
	\ {'h': $home },
	\ {'v': '~/vimfiles/vimrc' },
	\ {'V': '~/vimfiles' },
	\ {'s': '~/Onedrive/local/source' },
	\]
let g:startify_files_number = 5
let g:startify_session_autoload = true
let g:startify_change_to_dir = true
let g:startify_change_to_vcs_root = true
let g:startify_custom_indices = map(add(range(1,9), 0), 'string(v:val)')

" }}}

endif

" Options {{{1 ----------------------------------------------------------------

filetype plugin indent on
let $vim = $home . "/vimfiles"

" User Interface {{{2 ---------------------------------------------------------

" Line buffer at top/bottom when scrolling
set scrolloff=10

" Wild menu! Ignore obj, exe, .tup, .git
set wildmenu
set wildignore=*.o,*.exe
set wildignore+=*/.git/*,*/.tup/*

" searching stuff
set hlsearch
set ignorecase
set smartcase
set magic
set incsearch

" Don't redraw during macros
set lazyredraw

" No bells/flash
set noerrorbells
set novisualbell
set belloff=all

" Conceal
set conceallevel=2
set concealcursor=

" Hidden chars
set listchars=tab:\|\ ,extends:>,precedes:<,nbsp:%,trail:~
set list

" Line numbers
set number
set relativenumber

" Line wrapping, toggle bound to <space>tw
set nowrap
set linebreak

" Fold on triple brace
set foldmethod=marker
set foldlevel=999

" Make with tee
set shellpipe=2>&1\ \|\ tee

" hit-enter prompt
set shortmess=ilnxIT

" Split options
set splitright
" set splitbelow

" % for angle brackets
set matchpairs+=<:>

" Formatting {{{2 -------------------------------------------------------------

syntax enable

" Different theme for term/gui
if has('gui_running')
	colorscheme molokai
else
	colorscheme cs
endif

set background=dark

" gui-specified
if has('gui_running')
	set guifont=Consolas:h9:cANSI
	set guioptions-=T
endif

set encoding=utf-8

" Word formatting
set textwidth=0
set formatoptions=crqlnt

" Tempfiles {{{2 --------------------------------------------------------------

set backup
set backupdir=$VIM/tempfiles/backup//,$TEMP

set swapfile
set directory=$VIM/tempfiles/swap//,$TEMP

set undofile
set undodir=$VIM/tempfiles/undo//,$TEMP

" Editing {{{2 ----------------------------------------------------------------

" No timeout
set notimeout

" Clipboard
set clipboard=unnamed

" Automate
set autoindent
set autochdir
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

" C Indent {{{2 ---------------------------------------------------------------

" kernel style indents
set tabstop=8
set shiftwidth=0
set noexpandtab

set copyindent
set preserveindent

" c indent
set cino+=(0  " Contents of unclosed parentheses
set cino+=:0  " Case labels
set cino+=Ls  " Jump labels
set cino+=u0
set cino+=U0  " Do not ignore when parens are first char in line
set cino+=b0  " Align break with case
set cino+=g0  " Scope labels
set cino+=l1  " No align with label
set cino+=t0  " Function return type declarations

" Functions {{{1 --------------------------------------------------------------

function! ReloadAll() " {{{2
	" lightline
	if !exists('g:loaded_lightline')
		return
	endif
	try
		call lightline#init()
		call lightline#colorscheme()
		call lightline#update()
	catch
	endtry

	" fix width and height
	set columns=999 lines=999

	" fix syntax
	syntax sync fromstart

	" redraw
	redraw!
endfunction

function! LineHome() " {{{2
	let x = col('.')
	normal! ^
	if x <= col('.')
		normal! 0
	endif
endfunction

function! BufCleanup() " {{{2
	"From tabpagebuflist() help, get a list of all buffers in all tabs
	let tablist = []
	for i in range(tabpagenr('$'))
		call extend(tablist, tabpagebuflist(i + 1))
	endfor

	"Below originally inspired by Hara Krishna Dara and Keith Roberts
	"http://tech.groups.yahoo.com/group/vim/message/56425
	let nWipeouts = 0
	for i in range(1, bufnr('$'))
		if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
			"bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
			silent exec 'bwipeout' i
			let nWipeouts = nWipeouts + 1
		endif
	endfor
	echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

command! -nargs=0 KillBuffers call BufCleanup()

function! DumpOpts() " {{{2
	let msg = ''

	let vars = [ 'g:make_mode', 'g:make_args' ]

	for var in vars
		let msg .= "\n  " . var . "\t"
		if exists(var)
			let msg .= eval(var)
		else
			let msg .= "(undefined)"
		endif
	endfor

	echo msg[1:]
endfunction

function! ModVar(varname) " {{{2
	if !exists(a:varname)
		exec 'let ' . a:varname . ' = ""'
	endif
	exec 'let  ' . a:varname . ' = input(''' . a:varname . '? '',' . a:varname . ')'
endfunction

command! -narg=1 ISet call ModVar('<args>')

function! SystemExec() " {{{2
	let cmd = input('!', '', 'shellcmd')
	exec '!cls & ' . cmd
endfunction

function! Mkcabbr(abbr, expand) " {{{2
	exec 'cabbr ' . a:abbr . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expand . '" : "' . a:abbr . '"<CR>'
endfunction

function! Rename(newname) " {{{2
	exec 'saveas! ' . a:newname
	call vimproc#system('rm ' . expand('#'))
endfunction

command! -nargs=1 Rename call Rename('<args>')

function! MakeModeSwitch() " {{{2
	if !exists('g:make_mode')
		let g:make_mode = 'exe'
	endif

	if g:make_mode == 'exe'
		let g:make_mode = 'syn' " syntax checking [-fsyntax-only]
		echo '\m -> syntax check only'
	elseif g:make_mode == 'syn'
		let g:make_mode = 'obj' " object file, -c
		echo '\m -> object file'
	else
		let g:make_mode = 'exe' " fallback for unknown options
		echo '\m -> compile'
	endif
endfunction

function! Make() " {{{2
	let args = ''
	if !exists('g:make_args')
		let g:make_args = ''
	endif
	if !exists('g:make_mode')
		let g:make_mode = 'exe'
	endif

	if g:make_mode == 'exe'
		let args = '-o ' . expand('%:r') . '.exe'
	elseif g:make_mode == 'syn'
		let args = '-fsyntax-only'
	elseif g:make_mode == 'obj'
		let args = '-c -o ' . expand('%:r') . '.o'
	endif

	exec 'make! ' . args . ' ' . g:make_args
endfunction

function! Trim(str) " {{{2
	return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! ToggleWrap() " {{{2
	setl wrap!
	if &wrap
		echo "\w -> wrap"
		silent! noremap <buffer> <silent> 0 g0
		silent! noremap <buffer> <silent> ^ g^
		silent! noremap <buffer> <silent> $ g$
	else
		echo "\w -> nowrap"
		silent! unmap <buffer> 0
		silent! unmap <buffer> ^
		silent! unmap <buffer> $
	endif
endfunction

function! SudoRepeat() " {{{2
	let cmdline = split(@:)
	exec cmdline[0] . '! ' . join(cmdline[1:])
endfunction

function! ToTmpfile() " {{{2
	if exists("b:tmpfname") && !empty(b:tmpfname) && @% == b:tmpfname
		return
	endif

	if !empty(glob(@%))
		let b:tmpfname = @%
		return
	endif

	let b:tmpfname = tempname()
	if empty(@%)
		exec "w! " . b:tmpfname
	else
		exec "saveas! " . b:tmpfname
	endif
endfunction

function! TmpTags() " {{{2
	if !exists("b:tagfile")
		let b:tagfile = tempname()
		let &l:tags = b:tagfile
		au BufWritePost,FileWritePost <buffer> call TmpTags()
	endif

	let cmd = 'ctags -f ' . vimproc#shellescape(b:tagfile) . ' ' . vimproc#shellescape(expand('%:p'))
	call vimproc#system_bg(cmd)
endfunction

if !exists('*ExecFile') " {{{2

function! ExecFile()
	let ft = &ft
	if ft == "vim"
		so %
	elseif ft == "c" || ft == "cpp"
		!cls & "%:r.exe"
	elseif ft == "html" || ft == "registry"
		!"%"
	else
		echoe "Exec not defined for ft=" . ft
	endif
endfunction

endif

" Autocommands {{{1 -----------------------------------------------------------

augroup filetypes
	au!
	au Filetype markdown setl spell tw=80

	au BufNewFile,BufFilePre,BufRead *.tpp set filetype=cpp
	au BufNewFile,BufFilePre,BufRead *.h set filetype=c
	au Filetype c,cpp compiler gcc | compiler envcc
augroup END

" Bindings {{{1 ---------------------------------------------------------------

let mapleader = "\<Space>"

" better binds
noremap ; :
noremap zz za
noremap s <c-w>
noremap , ;
noremap <silent> 0 :call LineHome()<cr>
noremap U <c-r>
noremap <expr> <cr> empty(&buftype) ? '@@' : '<cr>'

noremap! <c-> <c-w>

" Registers, much easier to reach
noremap _ "_

noremap ! :call SystemExec()<cr>

noremap <leader> <nop>
noremap <silent> <leader><space> :nohl<cr>

" Buffer/Tab switching
noremap <silent> [b :bp<cr>
noremap <silent> ]b :bn<cr>
noremap <silent> [t :tabn<cr>
noremap <silent> ]t :tabp<cr>

" Complement <tab>
nnoremap <s-tab> <c-o>

" Logical lines
noremap j gj
noremap k gk

" Buffer ctl
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <c-left> <c-w><
nnoremap <c-down> <c-w>+
nnoremap <c-up> <c-w>-
nnoremap <c-right> <c-w>>

" misc
nnoremap <silent> <leader>rr :call ReloadAll()<cr>

" toggles
nnoremap <silent> <leader>oo :call DumpOpts()<cr>
nnoremap <silent> <leader>ow :call ToggleWrap()<cr>
nnoremap <silent> <leader>om :call MakeModeSwitch()<cr>
nnoremap <silent> <leader>ou :UndotreeToggle<cr>
nnoremap <silent> <leader>os :set scrollbind!<cr>
nnoremap <expr> <silent> <leader>od (&diff ? ":diffoff" : ":diffthis") . "<cr>"

" file ctl
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>aw :wa<cr>
nnoremap <leader>az :wqa<cr>
nnoremap <leader>aq :qa<cr>

nnoremap <leader>e. :e .<cr>
nnoremap <leader>ev :e $myvimrc<cr>
nnoremap <leader>x :call ExecFile()<cr>
nnoremap <leader>m :call Make()<cr>

" Splits
nnoremap <leader>s <nop>
nnoremap <silent> <leader>sh :aboveleft vertical new<cr>
nnoremap <silent> <leader>sk :aboveleft new<cr>
nnoremap <silent> <leader>sj :belowright new<cr>
nnoremap <silent> <leader>sl :belowright vertical new<cr>
nnoremap <leader>t :tab new<cr>

" unite binds
nnoremap <silent> <c-p> :UniteWithCurrentDir -profile-name=def file<cr>

" Other Features {{{1 ---------------------------------------------------------

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
