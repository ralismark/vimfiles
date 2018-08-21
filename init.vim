" Utility {{{1

let $VIM = fnamemodify($MYVIMRC, ':p:h')

" Plugins {{{1

if &loadplugins

" Vim-Plug {{{2

call plug#begin($VIM . '/plugged')

" Frameworks
Plug 'roxma/nvim-yarp'
Plug 'tpope/vim-repeat'

" UI
Plug 'chrisbra/Colorizer'
Plug 'equalsraf/neovim-gui-shim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'

" Workflow/Misc
Plug 'shougo/unite.vim' " TODO replace with shougo/denite once that matures enough
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'chrisbra/unicode.vim'

" Syntax/Language
"Plug 'jceb/vim-orgmode'
Plug 'lvht/tagbar-markdown'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Editing
Plug 'christoomey/vim-sort-motion'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'ralismark/itab'
Plug 'sgur/vim-textobj-parameter'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-abolish'

" Completion/Snips/Lint
Plug 'ncm2/ncm2'
" some completion sources
Plug 'Shougo/neco-syntax' | Plug 'jsfaint/ncm2-syntax'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-pyclang'
"Plug 'sirver/ultisnips'
Plug 'w0rp/ale'

" System
Plug '/usr/share/vim/vimfiles'

Plug $VIM . '/bundle/etypehead'
Plug $VIM . '/bundle/orgmode'
Plug $VIM . '/bundle/recover'
Plug $VIM . '/bundle/syn'
Plug $VIM . '/bundle/uwiki'
Plug $VIM . '/bundle/vimrc'

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
\	'no_split': 1,
\	'prompt': '⇒ ',
\	'prompt_direction': 'top',
\	'start_insert': 1,
\	'here': 1,
\ })

call unite#custom#profile('preview', 'context', {
\	'prompt': '⇒ ',
\	'prompt_direction': 'top',
\	'start_insert': 1,
\	'auto_preview': 1,
\	'vertical': 1,
\	'hide_source_names': 1,
\ })

augroup vimrc_Unite
	au!

	au Filetype unite imap <buffer> <esc> <Plug>(unite_exit)
augroup END

" vim-easy-align {{{2

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Lightline {{{2

set laststatus=2
set showmode
set showtabline=2

let g:lightline = {
\	'enable': {
\		'statusline': 0,
\		'tabline': 1,
\	},
\	'component': {
\		'paste': '%{&paste ? "paste" : ""}',
\		'spell': '%{&spell ? (winwidth(0) > 80 ? "s:" . &spelllang : winwidth(0) > 50 ? "s..." : "") : ""}',
\	},
\	'component_function': {
\		'filename': 'll#filename',
\		'location': 'll#location',
\		'rostate': 'll#rostate',
\		'filetype': 'll#filetype',
\		'fileinfo': 'll#fileinfo',
\		'bufinfo': 'll#bufinfo',
\		'wordcount': 'll#wordcount'
\	},
\	'component_visible_condition': {
\		'filetype': '(winwidth(0) > 40)',
\		'spell': '(&spell && winwidth(0) > 50)',
\		'wordcount': '(&spell && winwidth(0) > 50)',
\	},
\	'active': {
\		'left': [
\				[ 'paste' ],
\				[ 'filename', 'rostate' ],
\				[ 'wordcount' ],
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
\				[ 'filetype' ],
\			],
\	},
\	'tabline': {
\		'left': [
\				[ 'tabs' ],
\		],
\		'right': [
\		],
\	},
\
\	'colorscheme': 'wombat',
\
\	'separator': { 'left': '', 'right': '' },
\	'subseparator': { 'left': '', 'right': '' },
\
\	'tabline_separator': { 'left': '', 'right': '' },
\	'tabline_subseparator': { 'left': '', 'right': '' },
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

let g:startify_files_number = 10
let g:startify_session_autoload = 1
let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = map(add(range(1,9), 0), 'string(v:val)')

au User Startified nnoremap <buffer> q :q<cr>

" UltiSnips {{{2

let g:UltiSnipsSnippetsDir = $VIM . "/snips"
let g:UltiSnipsSnippetDirectories = [ g:UltiSnipsSnippetsDir, 'UltiSnips' ]

let g:UltiSnipsExpandTrigger = "<f20>"
let g:UltiSnipsListSnippets = "<f21>"

inoremap <silent> <s-bs> <c-r>=(UltiSnips#ExpandSnippetOrJump()) ? "" : ""<cr>

" Nvim Completion Manager {{{2

imap <expr> <tab> pumvisible() ? "\<c-n>" : "\<Plug>ItabTab"
imap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
imap <expr> <cr> pumvisible() ? "\<c-y>\<Plug>ItabCr" : "\<Plug>ItabCr"

let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

augroup vimrc_Ncm
	au!

	" Enable for everything right now
	autocmd BufEnter * call ncm2#enable_for_buffer()

	au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
	au User Ncm2PopupClose set completeopt=menuone
augroup END

" netrw {{{2

" My main use case is :Lexplore for a side panel

let g:netrw_banner = 0 " no banner
let g:netrw_browse_split = 4 " open in previous window
let g:netrw_winsize = -35 " split is 40 cols wide

" ALE {{{2

" Default to off
let g:ale_enabled = 1

" dont lint while typing
let g:ale_lint_on_text_changed = "normal"

" lint on insert exit
let g:ale_lint_on_insert_leave = 1

" Show linter
let g:ale_echo_msg_format = "[%linter%] %(code): %%s [%severity%]"

" Linters to use.
let g:ale_linters = {}
let g:ale_linters.html = [ 'HTMLHint', 'tidy' ]
let g:ale_linters.cpp = [ 'clangtidy', 'clangcheck' ] " clang, for live feedback, and others, for depth
let g:ale_linters.c = g:ale_linters.cpp

" Mostly for competition stuff, so we don't get unnecessary issues
" -llvm-include-order: not important
" -google-build-using-namespace: mostly use of use namespace std, which is faster
" -cppcoreguidelines-owning-memory: no gtl::owner<>
" -cppcoreguidelines-pro-type-vararg and -hicpp-vararg: for cstdio
" -fuchsia-*: they're all weird
let g:ale_cpp_clangtidy_checks = [ '*',
\ '-llvm-include-order',
\ '-google-build-using-namespace',
\ '-cppcoreguidelines-owning-memory',
\ '-cppcoreguidelines-pro-type-vararg', '-hicpp-vararg',
\ '-fuchsia-*'
\ ]

let g:ale_linter_aliases = {
\	'pandoc': 'markdown',
\ }

let g:ale_sign_error = '><'
let g:ale_sign_warning = '◀▶'

" Tagbar {{{2

let g:tagbar_sort = 0

" }}}

endif

" Options {{{1

" Misc {{{2

" Use Ag if possible
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor\ --column
	set grepformat=%f:%l:%c%m
endif

" Filetype local config {{{2

let ftconf = {}
let ftconf['pandoc'] = {
	\ '&et': 0,
	\ '&formatoptions': 'roqnlj',
	\ '&comments': 'b:-',
	\ '&spell': 1,
	\ '&ts': 4,
	\ '&wrap': 1,
	\ '&makeprg': 'pandoc "%" -o /tmp/preview.pdf $*',
	\ '&foldmethod': 'expr',
	\ '&foldexpr': 'PandocFold()',
	\ 'b:ale_enabled': 0,
	\ }
let ftconf['rst'] = 'pandoc'
let ftconf['markdown'] = 'pandoc'
let ftconf['rmd'] = {
	\ '': 'pandoc',
	\ '&makeprg': 'Rscript -e "rmarkdown::render(''%'', output_file=''/tmp/preview.pdf'', output_format=''pdf_document'')"',
	\ }
let ftconf['haskell'] = {
	\ '&et': 1,
	\ '&ts': 8,
	\ }
let ftconf['python'] = {
	\ '&omnifunc': 'python3complete#Complete',
	\ }
let ftconf['json'] = {
	\ '&conceallevel': 0,
	\ }
" C++ omni breaks things
let ftconf['cpp'] = {
	\ '&omnifunc': '',
	\ '&commentstring': '//%s',
	\ '&completefunc': 'rc#complete',
	\ '&iskeyword': 'a-z,A-Z,48-57,:,_',
	\ '&keywordprg': ':vertical Man 3std',
	\ }
let ftconf['c'] = 'cpp'
let ftconf['vim'] = {
	\ '&iskeyword': 'a-z,A-Z,48-57,_,:,$',
	\ '&keywordprg': ':vertical help'
	\ }
let ftconf['nofile'] = {
	\ '&buftype': 'nofile',
	\ }
let ftconf['plaintex'] = {
	\ '&makeprg': 'tex %',
	\ }
let ftconf['tex'] = {
	\ '&makeprg': 'tectonic %',
	\ }

" User Interface {{{2

" Man pages
set keywordprg=:Man

" Line buffer at top/bottom when scrolling
set scrolloff=15

" Wild menu!
set wildmenu

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
set listchars=tab:│\ ,extends:>,precedes:<,nbsp:%,trail:∙
set list
set fillchars=vert:│,fold:─,stl:─,stlnc:─

" Line numbers
set number
set relativenumber

" Line wrapping, toggle bound to <space>ow
set nowrap
set linebreak
set breakindent
set showbreak=↳\

" Fold on triple brace
set foldmethod=marker

" Minimal folding initially
set foldlevelstart=99

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

set swapfile
set undofile

if has('win32')
	set directory=$VIM/tempfiles/swap//,$TEMP//
	set undodir=$VIM/tempfiles/undo//,$TEMP//
else
	set directory=$VIM/tempfiles/swap//,/var/tmp//,/tmp//
	set undodir=$VIM/tempfiles/undo//,/var/tmp//,/tmp//
endif

call mkdir($VIM . '/tempfiles/swap', 'p')
call mkdir($VIM . '/tempfiles/undo', 'p')

" Editing {{{2

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

function! GetScriptlets() " {{{2
	let l:lines = getline(1, '$')
	let l:scriptletStart = match(l:lines, '^@@@@$')

	" No scriptlet defs
	if l:scriptletStart == 0
		return
	endif

	let l:slLines = l:lines[l:scriptletStart + 1 : ]
	let l:slSnips = []

	let l:lines = 0 " GC it - it may have been quite big

	" Join lines that don't begin with `@`
	for l:line in l:slLines
		if l:line[0] == '@'
			call add(l:slSnips, l:line)
		else
			if len(l:slSnips) > 0
				let l:slSnips[-1] .= l:line
			endif
		endif
	endfor

	" name -> lambda
	let l:slMapped = {}

	for l:snip in l:slSnips
		let l:end = matchend(l:snip, '^@.\{-\}:')
		let l:name = substitute(l:snip[1 : l:end - 2], '^\s*\(.\{-}\)\s*$', '\1', '')
		let l:expr = l:snip[l:end : ]

		let l:slMapped[l:name] = l:expr
	endfor

	return l:slMapped
endfunction

function! UpdateScriptlets() " {{{2
	" no scriptlet marker
	if !search('^@@@@$', 'cnw')
		return
	endif

	let l:scriptlets = GetScriptlets()
	let l:lines = map(getline(1, '$'), {k,v -> [k,v]})

	" only 3 @'s, not more
	let l:goodlines = filter(l:lines, {k,v -> v[1] =~ '^@@@@\@!'})

	let l:i = 0
	while l:i < len(l:goodlines)
		let l:line = l:goodlines[l:i]
		let l:i += 1

		if l:line[1] !~ '^@@@$' && l:i < len(l:goodlines)
			let l:endline = l:goodlines[l:i]
			let l:name = substitute(l:line[1], '^@@@\s*\(.\{-}\)\s*$', '\1', '')

			if l:line[0] + 1 <= l:endline[0] - 1
				silent exec (l:line[0] + 2) ',' (l:endline[0]) 'foldopen!'
				silent exec (l:line[0] + 2) ',' (l:endline[0]) 'd _'
			endif

			if !has_key(l:scriptlets, l:name)
				call append(l:line[0] + 1, '???')
			else
				try
					let l:Expr = eval(l:scriptlets[l:name])
					if type(l:Expr) == v:t_func
						let l:Expr = l:Expr()
					endif
				catch
					let l:Expr = '?!? ' . v:exception
				endtry

				call append(l:line[0] + 1, l:Expr)
			endif

			let l:i += 1
		endif
	endwhile
endfunction

function! ClearScriptlets() " {{{2
	" no scriptlet marker
	if !search('^@@@@$', 'cnw')
		return
	endif

	let l:lines = map(getline(1, '$'), {k,v -> [k,v]})

	" only 3 @'s, not more
	let l:goodlines = filter(l:lines, {k,v -> v[1] =~ '^@@@@\@!'})

	let l:i = 0
	while l:i < len(l:goodlines)
		let l:line = l:goodlines[l:i]
		let l:i += 1

		if l:line[1] !~ '^@@@$' && l:i < len(l:goodlines)
			let l:endline = l:goodlines[l:i]

			if l:line[0] + 1 <= l:endline[0] - 1
				silent exec (l:line[0] + 2) ',' (l:endline[0]) 'foldopen!'
				silent exec (l:line[0] + 2) ',' (l:endline[0]) 'd _'
			endif

			let l:i += 1
		endif
	endwhile
endfunction

function! GetSynClass() " {{{2
	return map(synstack(line('.'), col('.')), {k,v -> synIDattr(v, "name")})
endfunction

function! GetExecCurrent() " {{{2
	" Work for multiple filetypes
	for ft in split(&ft, '\.')
		if exists('l:Com')
			break
		endif

		if exists('b:exec_com')
			if type(b:exec_com) == v:t_dict
				if has_key(b:exec_com, ft)
					let Com = b:exec_com[ft]
				endif
			else
				let Com = b:exec_com
			endif
		endif
		if exists('g:exec_com') && !exists('l:Com')
			if type(g:exec_com) == v:t_dict
				if has_key(g:exec_com, ft)
					let Com = g:exec_com[ft]
				endif
			else
				let Com = g:exec_com
			endif
		endif
	endfor

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

	" reload syntax file
	let &ft=&ft

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

function! FtLayer(ft, ...) " {{{2
	" Revised FTConf for layers
	if a:0 > 0
		if index(a:1, a:ft) >= 0
			throw "Cyclic dependency with " . a:ft
		endif
		let chain = a:1 + [ a:ft ]
	else
		let chain = [ a:ft ]
	endif

	let val = get(g:ftconf, a:ft)

	if type(val) == v:t_string
		return FtLayer(val, chain)
	endif

	if type(val) == v:t_dict
		" Inherit values
		if has_key(val, '')
			let inherit = val['']
			if type(inherit) == v:t_string
				call FtLayer(inherit)
			elseif type(inherit) == v:t_list
				map(inherit, { k,v -> FtLayer(v) })
			endif
		endif

		for key in keys(val)
			if key == ''
				continue
			endif

			if key[0] == '&'
				exec 'let &l:' . key[1:] . ' = val[key]'
			else
				exec 'let ' . key . ' = val[key]'
			endif
		endfor
	endif
endfunction

" Autocommands {{{1

augroup vimrc
	au!

	" for proper nesting
	au TermOpen * let $NVIM_LISTEN_ADDRESS=v:servername

	au TermOpen * setl nonumber norelativenumber

	" Apply ftlayer options
	au Filetype * call FtLayer(expand('<amatch>'))

	au BufNewFile,BufFilePre,BufRead *.tpp set filetype=cpp
	" au BufNewFile,BufFilePre,BufRead *.h set filetype=c
	au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

	au Filetype *.*
		\ for t in split(&ft, '\.')
			\ | silent exe 'doautocmd vimrc FileType' t
		\ | endfor

	au Filetype markdown Knit
	au Filetype pandoc,rmd
		\ map <expr><buffer> ]] ({p -> p ? p . 'gg' : 'G' })(search('^#', 'Wnz'))
		\ | map <expr><buffer> [[ ({p -> p ? p . 'gg' : 'gg' })(search('^#', 'Wnbz'))

	au Filetype c,cpp runtime! syntax/doxygen.vim

	" Cursorline if not active
	setg cursorline
	au BufEnter,FocusGained,WinEnter * set nocursorline
	au User GoyoEnter setg nocursorline
	au User GoyoLeave setg cursorline
	au BufLeave,FocusLost,WinLeave * set cursorline<

	" Non-breaking autochdir
	au BufWinEnter * if empty(&buftype) | silent! lcd %:p:h | endif

	au FocusLost,VimLeavePre * if (&bt == '' && !empty(glob(bufname('%')))) || &bt == 'acwrite' | silent! update | endif
	au VimResized * wincmd =

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

" Commands {{{2

command! -nargs=0 W w !sudo tee %
command! -nargs=? -register ReTemplate call ReTemplate('<reg>')
command! -nargs=1 -complete=var ISet call ModVar('<args>')
command! -nargs=0 KillBuffers call BufCleanup()
command! -nargs=0 KillWhitespace StripWhitespace

command! -nargs=0 Knit call UpdateScriptlets()
command! -nargs=0 UnKnit call ClearScriptlets()

" Misc {{{2

" exec
noremap ! :silent<space>!

" readline/emacs mappings
noremap! <c-a> <home>
noremap! <a-d> <c-o>de
noremap! <c-e> <end>
noremap! <c-left> <c-d>
noremap! <c-right> <c-t>

" command line mappings
cnoremap <c-a> <home>
cnoreabbr <expr> %% expand('%')
cnoreabbr <expr> %p expand('%:p')
cnoreabbr <expr> %t expand('%:t')
cnoreabbr <expr> %r expand('%:r')
cnoreabbr <expr> %d expand('%:p:h')

" better binds
noremap ; :
noremap , ;
noremap <silent> <expr> 0 &wrap ? 'g0' : (match(getline('.'), '\S') >= 0 && match(getline('.'), '\S') < col('.') - 1 ? '^' : '0')
map <expr> <return> (&buftype == 'help' <bar><bar> expand("%:p") =~ '^man://') ? "\<c-]>" : (&buftype == 'quickfix' ? "\<CR>" : "@q")
noremap <s-return> @w
noremap Y y$

" overview
nnoremap <silent> gO :Tagbar<cr>

" Prose
nnoremap Q gwip
vnoremap Q gw
inoremap <c-q> <c-o>gwip
inoremap <c-s> <c-g>u<c-x>s

" Fixed I/A for visual
xnoremap <expr> I mode() ==# 'v' ? "\<c-v>I" : mode() ==# 'V' ? "\<c-v>^o^I" : "I"
xnoremap <expr> A mode() ==# 'v' ? "\<c-v>A" : mode() ==# 'V' ? "\<c-v>Oo$A" : "A"

" Folding
noremap <tab> za

" Since ^I == <tab>, we replace ^I with ^P
noremap <c-p> <c-i>

" Capital movement - we want nested mappings
map H 0
map L $
" Make K symmetric to J
nnoremap K m"i<cr><esc>`"

" Registers, much easier to reach
noremap _ "_
noremap - "_
noremap + "+

" Clear highlight
nnoremap <silent> <esc> :nohl<cr>

" Logical lines
noremap <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <expr> $ &wrap ? "g$" : "$"

" Keep visual
vnoremap < <gv
vnoremap > >gv

" Terminal {{{2

" escape as normal
tnoremap <esc> <c-\><c-n>

" c-r as normal
tnoremap <expr> <c-r> '<c-\><c-n>"'.nr2char(getchar()).'pi'

" Buffer/window/tab {{{2

" Buffer/Tab switching
noremap <silent> [b :bp<cr>
noremap <silent> ]b :bn<cr>
noremap <silent> [t :tabp<cr>
noremap <silent> ]t :tabn<cr>

" quickfix browse
noremap <silent> [c :cprev<cr>
noremap <silent> ]c :cnext<cr>

" Buffer ctl
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Leaders " {{{2

let mapleader = "\<Space>"

" more leaders
noremap <leader> <nop>
noremap <leader>x :call ExecCurrent()<cr>
noremap <leader>M :Dispatch<cr>
noremap <leader>m :Dispatch!<cr>

" misc
nnoremap <silent> <leader>rr :call ReloadAll()<cr>

" knit and unknit
nnoremap <silent> <leader>n :Knit<cr>
nnoremap <silent> <leader>N :UnKnit<cr>

" toggles
nnoremap <silent> <leader>oo :call DumpOpts()<cr>
nnoremap <silent> <leader>ow :set wrap!<cr>
nnoremap <silent> <leader>ou :UndotreeToggle<cr><c-w>999h
nnoremap <silent> <leader>os :set scrollbind!<cr>
nnoremap <silent> <leader>op :set paste!<cr>
nnoremap <silent> <leader>og :Goyo<cr>ze
nnoremap <silent> <leader>on :set number! relativenumber!<cr>
nnoremap <expr> <silent> <leader>od (&diff ? ':diffoff' : ':diffthis') . '<cr>'

" file ctl
nnoremap <leader>w :up<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>W :w!<cr>
nnoremap <leader>Q :q!<cr>
nnoremap <leader>aw :wa<cr>
nnoremap <leader>az :wqa<cr>
nnoremap <leader>aq :qa<cr>

nnoremap <leader>ee :e<cr>
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
nnoremap <silent> <leader>sv <c-w>v
nnoremap <silent> <leader>sh :aboveleft vertical new<cr>
nnoremap <silent> <leader>sk :aboveleft new<cr>
nnoremap <silent> <leader>sj :belowright new<cr>
nnoremap <silent> <leader>sl :belowright vertical new<cr>
nnoremap <leader>t :tab new<cr>

" unite binds
nnoremap <silent> <leader>ff :Unite -profile-name=def file file/new<cr>
nnoremap <silent> <leader>fr :Unite -profile-name=def file_rec/neovim<cr>
nnoremap <silent> <leader>fo :cd ~/org <bar> Unite -profile-name=preview -no-auto-preview file_rec/neovim file/new<cr>
nnoremap <silent> <leader>fl :Unite -profile-name=preview line<cr>
nnoremap <silent> <leader>fb :Unite -profile-name=def buffer<cr>

" Other Features {{{1

let g:exec_com = {
	\ 'vim': { -> execute('source %') },
	\ 'html': { -> jobstart(['xdg-open', expand('%:p')]) },
	\ 'rmd': { -> jobstart(['xdg-open', '/tmp/preview.pdf']) },
	\ 'pandoc': { -> jobstart(['xdg-open', '/tmp/preview.pdf']) },
	\ }

" Status Line
" 

function! MakeLine(components, splitter)
	call filter(a:components, {i,x -> !empty(x)})
	let out = join(a:components, a:splitter)
	if !empty(out)
		return ' ' . out
	endif
	return ''
endfunction

function! AppLine(component, splitter)
	if empty(a:component)
		return ''
	endif
	return a:splitter . a:component
endfunction

function! GetSL(w)
	if exists('#goyo')
		return ''
	endif

	let focus = a:w == winnr()

	if focus
		let co = {
		\	1: '%1*',
		\	2: '%2*',
		\	3: '%3*',
		\	4: '%4*',
		\	'ale': '%#SLError#',
		\}
	else
		let co = {
		\	1: '%6*',
		\	2: '%7*',
		\	3: '%8*',
		\	4: '%9*',
		\	'ale': '%#SLErrorI#',
		\}
	endif

	let winid = win_getid(a:w)
	let wininfo = get(getwininfo(winid), 0, {})
	let bufnr = get(wininfo, 'bufnr', -1)

	let stl = ''

	if ll#special(winid)
		let stl .= co[2] . '' . co[1] . ' %n%{ AppLine(ll#filename2(), "  ") } ' . co[2] . ' '
		let stl .= co[4] . '%<%{ repeat("' . (focus ? '━' : '─') . '", winwidth(0)) }>' " split
		return stl
	endif

	let stl .= co[2] . '' . co[1] . '%{ MakeLine([ bufnr(""), ll#filename() ], "  ") } ' . co[2] . ''
	let stl .= co[3] . '%{ MakeLine([ ' . (focus ? '&bt, ' : '') . 'll#rostate(), ll#wordcount() ], "  ") }'
	let stl .= co[4] . ' %<%{ repeat("' . (focus ? '━' : '─') . '", winwidth(0)) }>' " split
	let stl .= co[3] . '%{ MakeLine([ ll#eol(), ' . (focus ? 'll#filetype()' : 'll#nonfile() ? "" : &ft') . ' ], "  ") } '
	let stl .= co[2] . '' . co[1] . ' ' . co['ale'] . '%{ ll#ale() }' . co[1] . '%{ !empty(ll#ale()) ? "   " : "" }%{ ll#location() } ' . co[2] . ' '

	return stl
endfunction

function! RefreshSL()
	for i in range(1, winnr('$'))
		call setwinvar(i, '&statusline', '%!GetSL(' . i . ')')
	endfor
endfunction

function! EnableStatusLine()
	" Main bar
	hi User1    ctermfg=black ctermbg=white
	hi User6    ctermfg=black ctermbg=darkgrey
	" Main -> Secondary
	hi User2    ctermfg=white
	hi User7    ctermfg=darkgrey
	" Secondary
	hi User3    ctermfg=white
	hi User8    ctermfg=darkgrey
	" Middle
	hi User4    ctermfg=blue
	hi User9    ctermfg=darkgrey
	" ALE Error
	hi SLError  ctermfg=160   ctermbg=white    cterm=bold,underline
	hi SLErrorI ctermfg=124   ctermbg=darkgrey cterm=bold,underline

	augroup SL
		au!
		au VimEnter,WinEnter,BufWinEnter * call RefreshSL()
	augroup END

	call RefreshSL()
endfunction

function! DisableStatusLine()
	au! SL
endfunction

call EnableStatusLine()

au vimrc User GoyoEnter nested call DisableStatusLine()
au vimrc User GoyoLeave nested call EnableStatusLine()

" Stop plugins from pollution leader
let mapleader = "\\"
