set nocompatible

" Utility {{{1

let false = 0
let true = !false

let gui = has('gui_running') ? true : false
let con = !gui

let windows = has('win32') || has('win64')
let unix = has('unix')

let $VIM = fnamemodify($MYVIMRC, ':p:h')

" Plugins {{{1

" vim depth, when running vim inside vim

function! s:vimdepth() " {{{
	if !exists('g:vim_did_depth')
		let g:vim_did_depth = 1
	else
		return
	endif

	if !exists('$vim_depth')
		let $vim_depth = 0 " original root vim
	else
		let $vim_depth = $vim_depth + 1
	endif
endfunction

if exists('v:vim_did_enter')
	call s:vimdepth()
else
	au! VimEnter * call s:vimdepth()
endif

" }}}

if &loadplugins

" Vim-Plug {{{2

call plug#begin($VIM . '/plugged')

Plug 'chrisbra/Colorizer'
Plug 'christoomey/vim-sort-motion'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'lifepillar/vim-mucomplete'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sgur/vim-textobj-parameter'
Plug 'shougo/unite.vim' " TODO replace with shougo/denite once that matures enough
Plug 'sirver/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

Plug $VIM . '/bundle/vimrc'
Plug $VIM . '/bundle/recover'
Plug $VIM . '/bundle/itab'
Plug $VIM . '/bundle/etypehead'
Plug $VIM . '/bundle/syn'
Plug $VIM . '/bundle/uwiki'

call plug#end()

" Goyo {{{2

let g:goyo_width = 90



" Unite {{{2

call unite#filters#matcher_default#use(['matcher_context'])

" Using ag as recursive command.
let g:unite_source_rec_async_command =
\	[ 'ag', '--follow', '--nocolor', '--nogroup',
\	  '--hidden', '-g', '' ]

call unite#custom#profile('def', 'context', {
\	'no_split': true,
\	'prompt': '> ',
\	'prompt_direction': 'top',
\	'start_insert': true,
\	'here': true,
\ })

au Filetype unite call s:unite_settings()
function! s:unite_settings()
	imap <buffer> <esc> <Plug>(unite_exit)
endfunction

" vim-easy-align {{{2

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Lightline {{{2

if con == true
	set showtabline=2
endif

set laststatus=2
" set noshowmode

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
\
\		'spell': '%{&spell ? (winwidth(0) > 80 ? "s:" . &spelllang : winwidth(0) > 50 ? "s..." : "") : ""}',
\	},
\	'component_function': {
\		'filename': 'll#filename',
\		'location': 'll#location',
\		'rostate': 'll#rostate',
\		'filetype': 'll#filetype',
\		'fileinfo': 'll#fileinfo',
\		'bufinfo': 'll#bufinfo',
\		'depth': 'll#depth',
\	},
\	'component_visible_condition': {
\		'filetype': '(winwidth(0) > 40)',
\		'spell': '(&spell && winwidth(0) > 50)',
\	},
\	'active': {
\		'left': [
\				[ 'bufinfo' ],
\				[ 'filename', 'rostate' ],
\				[ 'spell' ],
\			],
\		'right': [
\				[ 'location' ],
\				[ 'filetype' ],
\			],
\	},
\	'inactive': {
\		'left': [
\				[ 'filename', 'rostate' ],
\				[ 'fileinfo' ],
\			],
\		'right': [
\				[ 'lineinfo' ],
\			],
\	},
\	'tabline': {
\		'left': [
\				[ 'depth', 'tabs' ],
\		],
\		'right': [
\				[ 'close' ],
\		],
\	},
\
\	'colorscheme': gui ? 'powerline' : 'll_theme',
\
\	'separator': gui ? { 'left': '', 'right': '' } : { 'left': '░', 'right': '░' },
\	'subseparator': gui ? {'left': '|', 'right': '|' } : { 'left': '░', 'right': '░' },
\
\	'tabline_separator': { 'left': '░', 'right': '░' },
\	'tabline_subseparator': { 'left': '', 'right': '' },
\ }

" Startify {{{2

let g:startify_session_dir = $VIM . '/session'
let g:startify_list_order = ['sessions', 'bookmarks', 'commands', 'files']
if getcwd() != $home
	call add(g:startify_list_order, 'dir')
endif

let g:startify_bookmarks = [
	\ {'h': $HOME },
	\ {'v': $MYVIMRC },
	\ {'V': $VIM },
	\]
if windows
	call add(g:startify_bookmarks, {'s': '~/Onedrive/local/source' })
endif

let g:startify_files_number = 10
let g:startify_session_autoload = true
let g:startify_change_to_dir = true
let g:startify_change_to_vcs_root = true
let g:startify_custom_indices = map(add(range(1,9), 0), 'string(v:val)')

au User Startified nnoremap <buffer> q :q<cr>

" UltiSnips {{{2

let g:UltiSnipsSnippetsDir = $VIM . "/snips"
let g:UltiSnipsSnippetDirectories = [ g:UltiSnipsSnippetsDir, 'UltiSnips' ]
let g:UltiSnipsNoMap = 1

let g:UltiSnipsExpandTrigger = "<f20>"
let g:UltiSnipsListSnippets = "<f21>"

inoremap <s-bs> <c-r>=(UltiSnips#ExpandSnippetOrJump()) ? "" : ""<cr>

" MuComplete {{{2

let g:mucomplete#chains = {
	\ 'default': [ 'ulti', 'user', 'omni', 'c-n' ],
	\ 'markdown': [ 'dict', 'uspl' ],
	\ 'cmake': [ 'path', 'c-n' ],
	\ }
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.default = {
	\ 'c-n': { t -> t !~# '[:punct:]$' }
	\ }

let g:mucomplete#no_mappings = true
imap <s-return> <plug>(MUcompleteFwd)
imap <c-s-return> <plug>(MUcompleteBwd)

" }}}

endif

" Options {{{1

" User Interface {{{2

" Line buffer at top/bottom when scrolling
set scrolloff=15

" Wild menu!
set wildmenu

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
set conceallevel=1
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
set shortmess=nxcIT

" Split options
set splitright
" set splitbelow

" % for angle brackets
set matchpairs+=<:>

" Show partial keypresses
set showcmd

" Formatting {{{2

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
set formatoptions=tcrqlnj

" Tempfiles {{{2

set swapfile
set undofile

if windows
	set directory=$VIM/tempfiles/swap//,$TEMP//
	set undodir=$VIM/tempfiles/undo//,$TEMP//
else
	set directory=$VIM/tempfiles/swap//,/var/tmp//,/tmp//
	set undodir=$VIM/tempfiles/undo//,/var/tmp//,/tmp//
endif

" Editing {{{2

" Mouse control
set mouse+=a

" Shell Options
set shellslash

" Completion
set completeopt=menu,menuone
set complete=.,w,b,t

" Modeline
set modeline

" Timeout
set notimeout
set ttimeout
set ttimeoutlen=100

" Clipboard
set clipboard=unnamed

" Automate
set autoindent
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

" C Indent {{{2

" kernel style indents
set tabstop=8
set shiftwidth=0
set noexpandtab
set smarttab

set copyindent
set preserveindent

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

if !exists('*ExecCurrent') " {{{2

function! ExecCurrent()
	let Fn=GetExecCurrent()
	if type(Fn) == v:t_func
		call Fn()
	endif
endfunction

endif

function! GetExecCurrent() " {{{2
	if exists('b:exec_com')
		if type(b:exec_com) == v:t_dict
			if has_key(b:exec_com, &ft)
				let Com = b:exec_com[&ft]
			endif
		else
			let Com = b:exec_com
		endif
	endif
	if exists('g:exec_com') && !exists('l:Com')
		if type(g:exec_com) == v:t_dict
			if has_key(g:exec_com, &ft)
				let Com = g:exec_com[&ft]
			endif
		else
			let Com = g:exec_com
		endif
	endif
	if !exists('l:Com')
		echoe 'ExecCurrent: no viable com found for filetype "' . &ft . '"'
		return
	endif

	return Com
endfunction

function! ReTemplate(reg) " {{{2
	let default = &cb =~ 'unnamed' ? '*' : &cb =~ 'unnamedplus' ? '+' : '"'
	let reg = len(a:reg) == 0 ? default : a:reg

	let rep = input('Replacement (empty to stop)? ')
	while rep != ''
		exe 'put' reg
		exe '''[,'']s/@/\=rep/g'
		exe "norm! \<esc>`]"

		redraw

		let rep = input('Replacement (empty to stop)? ')
	endwhile
endfunction

function! ReloadAll() " {{{2
	" lightline
	if exists('g:loaded_lightline')
		try
			call lightline#init()
			call lightline#colorscheme()
			call lightline#update()
		catch
		endtry
	endif

	" fix width and height
	set columns=999 lines=999

	" fix syntax
	syntax sync fromstart

	" redraw
	redraw!
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
	let vars = [ '&wrap', '&scrollbind', '&diff' ]
	let len = max(map(copy(vars), 'len(v:val)'))

	for var in vars
		let msg .= "\n  " . var . repeat(' ', len + 2 - len(var))
		if exists(var)
			let msg .= eval(var)
		else
			let msg .= '(undefined)'
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

function! RenameThis(force, newname) " {{{2
	if fnamemodify(a:newname, ':p') == expand('%:p')
		return
	endif
	exe (a:force ? 'saveas!' : 'saveas')  a:newname
	let oldname = expand('#')
	if delete(oldname) == -1
		" revert to old file
		echoe 'Rename failed! Reverting...'
		exe 'saveas!' . oldname
		if delete(a:newname) == -1
			echoe 'Revert failed! "' . a:newnae . '"may exist'
		endif
	endif
endfunction

function! DeleteThis(force) " {{{2
	if !a:force
		if &readonly
			echoe 'E45: ''readonly'' option is set (add ! to override)'
			return
		endif
		if !&modifiable
			echoe 'E21: cannot make change, ''modifiable'' is off (add ! to override)'
			return
		endif
	endif
	if delete(expand('%')) == -1
		" delete failed, not much to do
		echoe 'Delete failed!'
	endif
	q
endfunction

function! ToggleWrap() " {{{2
	setl wrap!
	if &wrap
		echo '\w -> wrap'
		silent! noremap <buffer> <silent> 0 g0
		silent! noremap <buffer> <silent> ^ g^
		silent! noremap <buffer> <silent> $ g$
	else
		echo '\w -> nowrap'
		silent! unmap <buffer> 0
		silent! unmap <buffer> ^
		silent! unmap <buffer> $
	endif
endfunction

" Autocommands {{{1

augroup vimrc
	au!
	au Filetype markdown,rst setl spell tw=80 sw=0 ts=4 noet
	au Filetype haskell setl sw=0 ts=8 et

	au BufNewFile,BufFilePre,BufRead *.tpp set filetype=cpp
	" au BufNewFile,BufFilePre,BufRead *.h set filetype=c

	au Filetype *.*
		\ for t in split(&ft, '\.')
			\ | silent exe 'doautocmd vimrc FileType' t
		\ | endfor

	au Filetype python setlocal omnifunc=python3complete#Complete

	au Filetype c,cpp
		\ setl commentstring=//%s
		\ | setl completefunc=rc#complete
		\ | setl iskeyword=a-z,A-Z,48-57,_
        	\ | runtime! syntax/doxygen.vim

	au Filetype vim
		\ setl iskeyword=a-z,A-Z,48-57,_,:,$

	au Filetype nofile,scratch
		\ set buftype=nofile

	au Filetype help
		\ if !&modifiable && &readonly
		\ | noremap <buffer> <nowait> <return> <c-]>
		\ | endif

	au Filetype plaintex
		\ let &l:makeprg='tex %'

	au Filetype tex
		\ let &l:makeprg='latex %'

	" Non-breaking autochdir
	au BufWinEnter * if empty(&buftype) | silent! lcd %:p:h | endif

	au FocusLost,VimLeavePre * if (&bt == '' && !empty(glob(bufname('%')))) || &bt == 'acwrite' | silent! update | endif
	au VimResized * exec "normal! \<c-w>="

	" Skeleton files
	au BufNewFile *
		\ for [fname, regpat] in map(glob($VIM . '/skeletons/{.,}*', 0, 1),
		\ 	{ k,v -> [v, glob2regpat('*' . fnamemodify(v, ':t'))] })
		\ | 	if expand('<afile>') =~# regpat
		\ | 		silent exec '0read' fname | silent $
		\ | 		break
		\ | 	endif
		\ | endfor

augroup END

" Bindings {{{1

" command line mappings
cnoremap <c-a> <home>
cnoreabbr <expr> %% expand('%:p:h')

" better binds
noremap ; :
noremap zz za
noremap s <c-w>
noremap , ;
noremap <silent> <expr> 0 match(getline('.'), '\S') < col('.') - 1 ? '^' : '0'
noremap U <c-r>
noremap <return> @q
noremap <s-return> @w
noremap Y y$

" Capital movement
map H 0
noremap L $

" gui variant
noremap! <c-bs> <c-w>
" console variant
noremap! <c-> <c-w>

" Registers, much easier to reach
noremap _ "_
noremap - "_

" Clear highlight
nnoremap <silent> <esc> :nohl<cr>

" Complement <tab>
nnoremap <s-tab> <c-o>

" Logical lines
noremap j gj
noremap k gk

" Commands {{{2

command! -nargs=? -register ReTemplate call ReTemplate('<reg>')
command! -nargs=1 -complete=var ISet call ModVar('<args>')
command! -nargs=1 -bang -bar RenameThis call RenameThis(<bang>0, <f-args>)
command! -nargs=0 -bang -bar DeleteThis call DeleteThis(<bang>0)
command! -nargs=0 KillBuffers call BufCleanup()
command! -nargs=0 KillWhitespace StripWhitespace

" Buffer/window/tab {{{2

" Buffer/Tab switching
noremap <silent> [b :bp<cr>
noremap <silent> ]b :bn<cr>
noremap <silent> [t :tabp<cr>
noremap <silent> ]t :tabn<cr>

" Buffer ctl
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <s-left> <c-w><
nnoremap <s-down> <c-w>+
nnoremap <s-up> <c-w>-
nnoremap <s-right> <c-w>>

" Leaders " {{{2

let mapleader = "\<Space>"

" more leaders
noremap <leader> <nop>
noremap <leader>x :call ExecCurrent()<cr>

" misc
nnoremap <silent> <leader>rr :call ReloadAll()<cr>

" toggles
nnoremap <silent> <leader>oo :call DumpOpts()<cr>
nnoremap <silent> <leader>ow :call ToggleWrap()<cr>
nnoremap <silent> <leader>ou :UndotreeToggle<cr><c-w>999h
nnoremap <silent> <leader>os :set scrollbind!<cr>
nnoremap <silent> <leader>op :set paste!<cr>
nnoremap <silent> <leader>og :Goyo<cr>ze
nnoremap <expr> <silent> <leader>od (&diff ? ':diffoff' : ':diffthis') . '<cr>'

" file ctl
nnoremap <leader>w :up<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>W :up!<cr>
nnoremap <leader>Q :q!<cr>
nnoremap <leader>aw :wa<cr>
nnoremap <leader>az :wqa<cr>
nnoremap <leader>aq :qa<cr>

nnoremap <leader>e. :e .<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>et :e $temp/test.cpp<cr>

" cleanup
nnoremap <leader>k <nop>
nnoremap <leader>kw :StripWhitespace<cr>
nnoremap <leader>kb :call BufCleanup()<cr>

" Splits
nnoremap <leader>s <nop>
nnoremap <silent> <leader>ss <c-w>s
nnoremap <silent> <leader>sh :aboveleft vertical new<cr>
nnoremap <silent> <leader>sk :aboveleft new<cr>
nnoremap <silent> <leader>sj :belowright new<cr>
nnoremap <silent> <leader>sl :belowright vertical new<cr>
nnoremap <leader>t :tab new<cr>

" unite binds
nnoremap <silent> <leader>ff :Unite -profile-name=def file<cr>
nnoremap <silent> <leader>fb :Unite -profile-name=def buffer<cr>

" Misc {{{2

" Add or remove indent
" inoremap <expr> <tab> "<c-\><c-o>>><end>" . repeat("<left>", col('$') - col('.'))
" inoremap <expr> <s-tab> "<c-\><c-o><<<end>" . repeat("<left>", col('$') - col('.'))
inoremap <tab> <c-t>
inoremap <s-tab> <c-d>

" Other Features {{{1

let g:exec_com = {
	\ 'vim': { -> execute('source %') },
	\ }
