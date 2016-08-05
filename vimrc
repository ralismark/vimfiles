set nocompatible
autocmd!
abclear

let false = 0
let true = !false

let gui = has('gui_running') ? true : false
let con = !gui

  " Plugins {{{1 --------------------------------------------------------------

runtime bundle/vim-pathogen/autoload/pathogen.vim

let g:pathogen_blacklist = ['delimitMate']
execute pathogen#infect()
Helptags

let g:cpp_class_scope_highlight = true

" gundo {{{ -------------------------------------------------------------------

let g:gundo_width = 60
let g:gundo_preview_height = 30

" vim-easy-align {{{2 ---------------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" lightline {{{2 --------------------------------------------------------------

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
\		'filename': '%n# %{winwidth(0) > 60 ? PartPath() : (len(expand("%")) > 0 ? expand("%") : "[Untitled]")}',
\
\		'fileformat': '%{&ff == "dos" ? "" : &ff == "unix" ? "\\n" : "\\r"}',
\
\		'spell': '%{&spell ? (winwidth(0) > 70 ? "s:" . &spelllang : winwidth(0) > 50 ? "s:" : "") : ""}',
\
\		'location': '%P %3l:%-2v',
\	},
\	'component_visible_condition': {
\		'fileformat': '(&ff != "dos")',
\		'spell': '(&spell && winwidth(0) > 50)',
\	},
\	'active': {
\		'left': [ [ 'mode' ],
\			  [ 'filename', 'rostate' ],
\			  [ 'spell' ], ],
\		'right': [ [ 'location' ],
\			   [ 'filetype', 'fileformat' ] ],
\	},
\	'inactive': {
\		'left': [
\				[ 'filename', 'rostate' ],
\				[ 'fileencoding', 'fileformat' ],
\			],
\		'right': [
\				[ 'lineinfo' ],
\			],
\	},
\	'colorscheme': gui ? 'powerline' : 'cs',
\	'separator': { 'left': '▓▒░', 'right': '░▒▓' },
\	'subseparator': { 'left': '░', 'right': '░' },
\ }

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

" CtrlP {{{2 ------------------------------------------------------------------

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_match_window = 'min:10,max:10'

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

" Make with tee
set shellpipe=2>&1\ \|\ tee

" hit-enter prompt
set shortmess=ilnxIT

" Split options
set splitright
set splitbelow

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

" kernel style indents
set tabstop=8
set shiftwidth=0
set noexpandtab

" Word formatting
set textwidth=0
set formatoptions=croqnl1j

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

set cino+=(s  " Contents of unclosed parentheses
set cino+=:0  " Case labels
set cino+=Ls  " Jump labels
set cino+=U1  " Do not ignore when parens are first char in line
set cino+=b0  " Align break with case
set cino+=g0  " Scope labels
set cino+=l1  " No align with label
set cino+=t0  " Function return type declarations

" Functions {{{1 --------------------------------------------------------------

function! LineHome() " {{{2
	let x = col('.')
	normal! ^
	if x == col('.')
		normal! 0
	endif
endfunction

function! PartPath() " {{{2
	if strlen(expand('%:p')) == 0
		return '[Untitled]'
	endif

	let parts = split(expand('%:p'), '\')
	let minipart = []
	if len(parts) < 3
		let minipart = parts
	else
		let minipart = parts[-3:-2]
	endif
	let fname = parts[-1]
	let str = ''
	for i in minipart
		let str .= i[:2] . '/'
	endfor

	return str . fname
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
	if !exists('g:make_mode') || g:make_mode == 'exe'
		let g:make_mode = 'exe'
		let args = ''
	elseif g:make_mode == 'syn'
		let args = '-fsyntax-only'
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

function! Rmtrails() " {{{2
	normal! mz
	%s/\s\+$//ge
	normal! `z

	return "<nop>"
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

augroup fts
	au!
	au Filetype markdown setl spell

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
noremap 0 :call LineHome()<cr>

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

" toggles
nnoremap <silent> <leader>oo :call DumpOpts()<cr>
nnoremap <silent> <leader>ow :call ToggleWrap()<cr>
nnoremap <silent> <leader>om :call MakeModeSwitch()<cr>
nnoremap <silent> <leader>ou :GundoToggle<cr>
nnoremap <silent> <leader>os :set scrollbind!<cr>

" file ctl
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>e. :e .<cr>
nnoremap <leader>ev :e $myvimrc<cr>
nnoremap <leader>x :call ExecFile()<cr>
nnoremap <leader>m :call Make()<cr>

" Splits
nnoremap <leader>s :new<cr>
nnoremap <leader>v :vert new<cr>
nnoremap <leader>t :tab new<cr>

" Other Features {{{1 ---------------------------------------------------------

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
