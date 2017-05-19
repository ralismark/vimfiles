set nocompatible
abclear

" Utility {{{1

let false = 0
let true = !false

let gui = has('gui_running') ? true : false
let con = !gui

let windows = has('win32') || has('win64')
let unix = has('unix')

if unix
	let $VIM = $HOME . '/.vim'
	let $myvimrc = $VIM . '/vimrc'
else
	let $VIM = $HOME . '/vimfiles'
endif

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

let g:cpp_class_scope_highlight = true

" Pathogen {{{2

let pathogen_blacklist = ['Recover.vim']

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
Helptags

" VimFiler {{{2

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_force_overwrite_statusline = 0

" Unite {{{2

call unite#filters#matcher_default#use(['matcher_fuzzy'])

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

" vimproc {{{2

let g:vimproc#download_windows_dll = true

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
\				[ 'tabs' ],
\		],
\		'right': [
\				[ 'close' ],
\		],
\	},
\
\	'colorscheme': gui ? 'powerline' : 'll_theme',
\
\	'separator': gui ? { 'left': '', 'right': '' } : { 'left': '▓▒░', 'right': '░▒▓' },
\	'subseparator': gui ? {'left': '|', 'right': '|' } : { 'left': '░', 'right': '░' },
\
\	'tabline_separator': { 'left': '░', 'right': '░' },
\	'tabline_subseparator': { 'left': '', 'right': '' },
\ }

" Startify {{{2

let g:startify_session_dir = '~/vimfiles/session'
let g:startify_list_order = ['sessions', 'bookmarks', 'commands', 'files']
if getcwd() != $home
	call add(g:startify_list_order, 'dir')
endif

let g:startify_bookmarks = [
	\ {'h': $HOME },
	\ {'v': $VIM . '/vimrc' },
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

" MuComplete {{{2

let g:mucomplete#chains = {
	\ 'default': [ 'user', 'keyn', 'omni' ],
	\ 'markdown': [ 'dict', 'uspl' ],
	\ }
let g:mucomplete#can_complete = {
	\ 'default' : {
	\ 	'dict':  { t -> strlen(&l:dictionary) > 0 },
	\ 	'file':  { t -> t =~# '/' },
	\ 	'omni':  { t -> strlen(&l:omnifunc) > 0 },
	\ 	'spel':  { t -> &l:spell },
	\ 	'tags':  { t -> !empty(tagfiles()) },
	\ 	'thes':  { t -> strlen(&l:thesaurus) > 0 },
	\ 	'user':  { t -> strlen(&l:completefunc) > 0 },
	\ 	},
	\ }
let g:mucomplete#no_mappings = true
imap <s-return> <plug>(MUcompleteFwd)
imap <c-s-return> <plug>(MUcompleteBwd)

" CMake {{{

let g:cmake_generator = 'Ninja'
let g:cmake_compiler = 'clang-cl'

" }}}

endif

" Options {{{1

filetype plugin indent on
let $vim = $home . "/vimfiles"

" User Interface {{{2

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
set conceallevel=0
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
set shortmess=nxcIT

" Split options
set splitright
" set splitbelow

" % for angle brackets
set matchpairs+=<:>

" Formatting {{{2

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

" Tempfiles {{{2

set backup
set swapfile
set undofile

if windows
	set directory=$VIM/tempfiles/swap//,$TEMP//
	set backupdir=$VIM/tempfiles/backup//,$TEMP//
	set undodir=$VIM/tempfiles/undo//,$TEMP//
else
	set directory=$HOME/.vim/swap//,/var/tmp//,/tmp//
	set backupdir=$HOME/.vim/backup//,/var/tmp//,/tmp//
	set undodir=$HOME/.vim/undo//,/var/tmp//,/tmp//
endif

" Editing {{{2

" Shell Options
set shellslash

" Completion
set completeopt=menu,menuone
set infercase
set complete=.,w,b,t,i,d

" Modeline
set nomodeline

" No timeout
set notimeout

" Clipboard
set clipboard=unnamed

" Automate
set autoindent
" set autochdir
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

function! Sort(type, ...) " {{{2
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	let type = a:type

	if a:0
		if a:type ==# 'v'
			let type = 'char'
		elseif a:type ==# 'V'
			let type = 'line'
		else
			let type = 'block'
		endif
	endif

	let range = a:0 ? '<>' : '[]'

	if type == 'char'
		silent exe 'normal! `' . range[0] . 'v`' . range[1] . 'y'

		let chars = filter(split(@@, '.\zs'), { key, val -> match(val, '[[:cntrl:]]') })
		let @@ = join(sort(chars), '')

		silent exe 'normal! `' . range[0] . 'v`' . range[1] . 'c' . @@
	else
		silent exe "'" . range[0] . ",'" . range[1] . 'sort /\ze\%V/'
	endif

	let &selection = sel_save
	let @@ = reg_save
endfunction

function! ShellLine() " {{{2
	let cmd = input(getcwd() . '> ', '', 'file')
	if cmd =~ '^\s*$'
		return
	endif
	exe 'AsyncRun! ' . cmd
	copen
endfunction

function! GetLocalIncludes(base) " {{{2
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
endfunction

function! Completion(findstart, base) " {{{2
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
			return CompleteInclude(line, a:base)
		endif
	endif

	if a:findstart == 1
		return -3
	endif
endfunction

function! CompleteInclude(line, base) " {{{2
	let out = []
	if match(a:line, '^\s*#\s*include\s*"') > -1
		let out = GetLocalIncludes(a:base)
	elseif match(a:line, '^\s*#\s*include\s*<') > -1
		let words = FindInPathList(a:base . '*', $include)

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
endfunction

function! FindInPathList(file, path) " {{{2
	let path = substitute(substitute(a:path, ';', ',','g'), '\', '/', 'g')
	let pathlist = split(path, ',')

	let pathexpr = '\V\^\(\(' . join(pathlist, '\)\|\(') . '\)\)/\?'
	let results = map(map(globpath(path, a:file, 0, 1), 'v:val . (isdirectory(v:val) ? "/" : "")'), 'substitute(v:val, "\\", "/", "g")')

	return map(results, 'substitute(v:val, pathexpr, "", "")')
endfunction

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
	let vars = [ 'g:make_mode', 'g:make_args', '&wrap', '&scrollbind', '&diff' ]
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

command! -narg=1 -complete=var ISet call ModVar('<args>')

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

command! -nargs=1 -bang -bar RenameThis call RenameThis(<bang>0, "<args>")

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
endfunction

command! -nargs=0 -bang -bar DeleteThis call DeleteThis(<bang>0)

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
	au Filetype markdown setl spell tw=80

	au BufNewFile,BufFilePre,BufRead *.tpp set filetype=cpp
	au BufNewFile,BufFilePre,BufRead *.h set filetype=c

	au Filetype *.*
		\ for t in split(&ft, '\.')
			\ | silent exe 'doautocmd vimrc FileType' t
		\ | endfor

	au Filetype c,cpp
		\ setl commentstring=//%s
		\ | setl completefunc=Completion
		\ | setl iskeyword=a-z,A-Z,48-57,_
        	\ | runtime! syntax/doxygen.vim

	au Filetype vim
		\ setl iskeyword=a-z,A-Z,48-57,_,:,$

	au Filetype nofile,scratch
		\ set buftype=nofile

	" Non-breaking autochdir
	au BufWinEnter * if empty(&buftype) | silent! lcd %:p:h | endif

	au FocusLost,VimLeavePre * if (&bt == '' && !empty(glob(bufname('%')))) || &bt == 'acwrite' | silent! w | endif
	au VimResized * exec "normal! \<c-w>="
augroup END

" Bindings {{{1

command! -nargs=0 KillBuffers call BufCleanup()
command! -nargs=0 KillWhitespace StripWhitespace

let mapleader = "\<Space>"

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
noremap ! :call ShellLine()<cr>

" sort operator
nnoremap <silent> gs :set opfunc=Sort<cr>g@
nnoremap <silent> gss <nop>
vnoremap <silent> gs :<c-u>call Sort(visualmode(), 1)<cr>

" gui variant
noremap! <c-bs> <c-w>
" console variant
noremap! <c-> <c-w>

" Registers, much easier to reach
noremap _ "_
noremap - "_

" more leaders
noremap <leader> <nop>
noremap <silent> <leader><space> :nohl<cr>

" Buffer/Tab switching
noremap <silent> [b :bp<cr>
noremap <silent> ]b :bn<cr>
noremap <silent> [t :tabp<cr>
noremap <silent> ]t :tabn<cr>

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

nnoremap <s-left> <c-w><
nnoremap <s-down> <c-w>+
nnoremap <s-up> <c-w>-
nnoremap <s-right> <c-w>>

" misc
nnoremap <silent> <leader>rr :call ReloadAll()<cr>

" toggles
nnoremap <silent> <leader>oo :call DumpOpts()<cr>
nnoremap <silent> <leader>ow :call ToggleWrap()<cr>
nnoremap <silent> <leader>om :call rc#make_mode_switch()<cr>
nnoremap <silent> <leader>ou :UndotreeToggle<cr>
nnoremap <silent> <leader>os :set scrollbind!<cr>
nnoremap <expr> <silent> <leader>od (&diff ? ':diffoff' : ':diffthis') . '<cr>'

" file ctl
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>W :w!<cr>
nnoremap <leader>Q :q!<cr>
nnoremap <leader>aw :wa<cr>
nnoremap <leader>az :wqa<cr>
nnoremap <leader>aq :qa<cr>

nnoremap <leader>e. :e .<cr>
nnoremap <leader>ev :e $myvimrc<cr>
nnoremap <leader>et :e $temp/test.cpp<cr>
nnoremap <leader>m :call rc#make()<cr>

" Splits
nnoremap <leader>s <nop>
nnoremap <silent> <leader>ss <c-w>s
nnoremap <silent> <leader>sh :aboveleft vertical new<cr>
nnoremap <silent> <leader>sk :aboveleft new<cr>
nnoremap <silent> <leader>sj :belowright new<cr>
nnoremap <silent> <leader>sl :belowright vertical new<cr>
nnoremap <leader>t :tab new<cr>

" unite binds
nnoremap <silent> <leader>fv :exe 'VimFiler' expand('%:p:h')<cr>
nnoremap <silent> <leader>ff :UniteWithCurrentDir -profile-name=def file<cr>
nnoremap <silent> <leader>fb :UniteWithCurrentDir -profile-name=def buffer<cr>

" Other Features {{{1

" Async Make
command! -nargs=* AsyncMake exec 'AsyncRun ' . rc#make_command('<args>')

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
