" vim: set foldmethod=marker:

let g:configdir = fnamemodify($MYVIMRC, ':p:h')

" Plugins {{{1

command! -nargs=+ NXnoremap  nnoremap <args>|xnoremap <args>
command! -nargs=+ NXmap      nmap <args>|xmap <args>

if &loadplugins

" Vim-Plug {{{2

call plug#begin(g:configdir . '/plugged')

" Frameworks
Plug 'roxma/nvim-yarp'
Plug 'tpope/vim-repeat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" UI
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'

" Workflow/Misc
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'ralismark/vim-recover'

" Syntax/Language
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'sheerun/vim-polyglot'
" Plug 'hsanson/vim-android'
Plug 'mzlogin/vim-smali'
Plug 'ralismark/nvim-tabletops'

" Editing
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'ralismark/itab'
Plug 'sgur/vim-textobj-parameter'
Plug 'tomtom/tcomment_vim'

" Completion/Snips/Lint
Plug 'ncm2/ncm2'
" some completion sources
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'

Plug 'sirver/ultisnips'
Plug 'w0rp/ale'

" System
Plug '/usr/share/vim/vimfiles'

" Plug g:configdir . '/bundle/etypehead'
Plug g:configdir . '/bundle/syn'
Plug g:configdir . '/bundle/vimrc'

call plug#end()

" COC {{{2

let g:coc_global_extensions = [ 'coc-clangd', 'coc-rls', 'coc-json' ]

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

command! -nargs=* CocHover call CocAction('doHover')

" Tab completion
imap <silent><expr> <tab>
	\ pumvisible() ? "\<c-n>"
	\ : (col('.') < 2 <bar><bar> getline('.')[col('.') - 2] =~ '\s') ? "\<Plug>ItabTab"
	\ : coc#refresh()
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\t"

" Goyo {{{2

let g:goyo_width = 90

" vim-polyglot {{{2

let g:polyglot_disabled = ['latex']

" vim-easy-align {{{2

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" UltiSnips {{{2

let g:UltiSnipsSnippetsDir = g:configdir . "/snips"
let g:UltiSnipsSnippetDirectories = [ g:UltiSnipsSnippetsDir, 'UltiSnips' ]

let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
let g:UltiSnipsListSnippets = "<Plug>(ultisnips_list)"

let g:UltiSnipsJumpForwardTrigger = "<c-space>"
let g:UltiSnipsJumpBackwardTrigger = "<c-s-space>"

inoremap <silent> <Plug>(ultisnips_expand_or_jump) <cmd>call UltiSnips#ExpandSnippetOrJump()<cr>
snoremap <silent> <Plug>(ultisnips_expand_or_jump) <Esc><cmd>call UltiSnips#ExpandSnippetOrJump()<cr>

let g:UltiSnipsRemoveSelectModeMappings = 1
let g:UltiSnipsMappingsToIgnore = [ "UltiSnip#" ]

" ALE {{{2

" Default to on
let g:ale_enabled = 0

" dont lint while typing
let g:ale_lint_on_text_changed = "normal"

" lint on insert exit
let g:ale_lint_on_insert_leave = 1

" Show linter
let g:ale_echo_msg_format = "[%linter%] %(code): %%s [%severity%]"

" Linters to use.
let g:ale_linters = {}
let g:ale_linters.html = [ 'HTMLHint', 'tidy' ]
let g:ale_linters.cpp = [ 'clang', 'clangcheck' ] " clang, for live feedback, and others, for depth
let g:ale_linters.c = g:ale_linters.cpp
let g:ale_linters.python = [ 'pylint' ]
let g:ale_linters.java = [ 'android' ]
let g:ale_linters.perl = [ 'perl' ]

" parse compile_commands.json and Makefile
" let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 0

let g:ale_cpp_clang_options = '-std=c++17 -Wall -Wextra -Wshadow'
let g:ale_cpp_clangcheck_options = '-extra-arg=-std=c++17'

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

let g:ale_python_pylint_options = '-d missing-docstring,wrong-import-position'

let g:ale_sign_error = '><'
let g:ale_sign_warning = '◀▶'

" Dispatch {{{2

let g:dispatch_no_maps = 1

endif

" Options {{{1

" Misc {{{2

" Use Ag if possible
if executable('ag')
	let &grepprg = "ag --nogroup --nocolor --column $*"
	set grepformat=%f:%l:%c%m
endif

set diffopt+=algorithm:patience,indent-heuristic

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
	\ '&ts': 4,
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
	\ '&iskeyword': 'a-z,A-Z,48-57,_',
	\ '&keywordprg': ':vertical Man 3std',
	\ }
let ftconf['c'] = 'cpp'
let ftconf['vim'] = {
	\ '&iskeyword': 'a-z,A-Z,48-57,_,#,$',
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
	\ '&iskeyword': '@,48-57,_,*',
	\ 'b:tex_isk': '@,48-57,_,*',
	\ }
let ftconf['dot'] = {
	\ '&makeprg': 'dot -Tpdf % -o/tmp/preview.pdf'
	\ }
let ftconf['html'] = {
	\ '&et': 1,
	\ '&ts': 2,
	\ }
let ftconf['htmldjango'] = 'html'
let ftconf['javascript'] = {
	\ '&et': 1,
	\ '&ts': 2,
	\ }

" User Interface {{{2

" Status line
set laststatus=2
set showmode
set showtabline=2

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
set fillchars=eob:\ ,vert:│,fold:─,stl:─,stlnc:─

" Line numbers
set number

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

function! PandocFold() " {{{2
	let depth = match(getline(v:lnum), '\(^#\+\)\@<=\( .*$\)\@=')
	return depth > 0 ? '>' . depth : '='
endfunction

function! SortMotion(motion) " {{{2
	if a:motion ==# "line"
		exec "'[,']sort"
	elseif a:motion ==# "\<c-v>"
		let scol = virtcol("v")
		let ecol = virtcol(".")
		let regex = '/\%' . scol . 'v.*\%<' . (ecol + 1) . 'v/'
		let sel = sort([ line("v"), line(".") ])
		exec sel[0] . "," . sel[1] . "sort" regex
		exec "normal \<esc>"
	elseif a:motion ==# "V"
		let sel = sort([ line("v"), line(".") ])
		exec sel[0] . "," . sel[1] . "sort"
		exec "normal \<esc>"
	endif
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

		if exists('b:execprg')
			if type(b:execprg) == v:t_dict
				if has_key(b:execprg, ft)
					let Com = b:execprg[ft]
				endif
			else
				let Com = b:execprg
			endif
		endif
		if exists('g:execprg') && !exists('l:Com')
			if type(g:execprg) == v:t_dict
				if has_key(g:execprg, ft)
					let Com = g:execprg[ft]
				endif
			else
				let Com = g:execprg
			endif
		endif
	endfor

	if type(Com) == v:t_string || type(Com) == v:t_list
		let args = Com
		let Com = { -> jobstart(args) }
	endif

	if !exists('l:Com')
		echoe 'ExecCurrent: no viable com found for filetype "' . &ft . '"'
		return
	endif

	return Com
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
	au BufNewFile,BufFilePre,BufRead *.s set filetype=mips

	au Filetype *.*
		\ for t in split(&ft, '\.')
		\ | 	silent exe 'doautocmd vimrc FileType' t
		\ | endfor

	au Filetype pandoc,rmd
		\ noremap <expr><buffer> ]] ({p -> p ? p . 'gg' : 'G' })(search('^#', 'Wnz'))
		\ | noremap <expr><buffer> [[ ({p -> p ? p . 'gg' : 'gg' })(search('^#', 'Wnbz'))

	au Filetype c,cpp runtime! syntax/doxygen.vim

	" Cursorline if not active
	setg cursorline
	au BufEnter,FocusGained,WinEnter * set nocursorline
	au User GoyoEnter setg nocursorline
	au User GoyoLeave setg cursorline
	au BufLeave,FocusLost,WinLeave * set cursorline<

	" Non-breaking autochdir
	au BufWinEnter * if empty(&buftype) | silent lcd %:p:h | endif

	au FocusLost,VimLeavePre *
		\ if (&bt == '' && !empty(glob(bufname('%')))) || &bt == 'acwrite'
		\ | 	silent update
		\ | endif
	au VimResized * wincmd =

	" Skeleton files
	au BufNewFile *
		\ for fname in glob(g:configdir . '/skeletons/{.,}*', v:false, v:true)
		\ | 	if expand('<afile>') =~# glob2regpat('*' . fnamemodify(fname, ':t'))
		\ | 		silent exec '0read' fname | silent $d | silent $
		\ | 		break
		\ | 	endif
		\ | endfor

augroup END

" Bindings {{{1

" Commands {{{2

command! -bar -nargs=0 W w !pkexec tee %:p >/dev/null | setl nomod
" This, for some reason, doesn't work if you put it in a function
command! -nargs=+ Keepview let s:view_save = winsaveview() | exec <q-args> | call winrestview(s:view_save)
command! -nargs=+ -complete=file Fork call jobstart(<q-args>)

" Misc {{{2

NXnoremap <left> zh
NXnoremap <right> zl
NXnoremap <up> <c-y>
NXnoremap <down> <c-e>

" readline/emacs mappings
noremap! <c-a> <home>
noremap! <a-d> <c-o>de
noremap! <c-e> <end>
" need to get used to this so I stop accidentally closing windows in other programs
noremap! <c-bs> <c-w>

" better binds
noremap ; :
noremap , ;
noremap ' `
noremap <silent> <expr> 0 &wrap ? 'g0' : '0'
map <expr> <return> (or(&buftype == 'help', expand("%:p") =~ '^man://')) ? "\<c-]>" : (&buftype == 'quickfix' ? "\<CR>" : "@q")
command! -nargs=0 -range=% KillWhitespace Keepview <line1>,<line2>s/[\x0d[:space:]]\+$//e | nohl
NXnoremap <expr> G &wrap ? "G$g0" : "G"
noremap <s-return> @w
nnoremap Y y$
nnoremap g= 1z=
xnoremap p pgvy

" sort motion
nnoremap gs <cmd>set operatorfunc=SortMotion<cr>g@
xnoremap gs <cmd>call SortMotion(mode())<cr>

" Fast replace shortcuts
nnoremap s :%s/\v
xnoremap s :s/\v

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

" Register-preserving delete
NXmap X "_d
nmap XX "_dd
nnoremap x "_x

" Terminal {{{2

" escape as normal
tnoremap <esc> <c-\><c-n>

" Buffer/window/tab {{{2

" Buffer/Tab switching
nnoremap <silent> [b :bp<cr>
nnoremap <silent> ]b :bn<cr>
nnoremap <silent> [t :tabp<cr>
nnoremap <silent> ]t :tabn<cr>

" quickfix browse
nnoremap <silent> [c :cprev<cr>
nnoremap <silent> ]c :cnext<cr>
nnoremap <silent> [l :lprev<cr>
nnoremap <silent> ]l :lnext<cr>

" Buffer ctl
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Leaders " {{{2

let mapleader = "\<Space>"

" more leaders
nnoremap <leader> <nop>
nnoremap <leader>x :call ExecCurrent()<cr>
nnoremap <leader>m :Dispatch<cr>

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
nnoremap <expr> <silent> <leader>od (&diff ? '<cmd>diffoff' : '<cmd>diffthis') . ' <bar> set diff?<cr>'

" file ctl
nnoremap <leader>w <cmd>up<cr>
nnoremap <leader>q <cmd>q<cr>

nnoremap <leader>ev <cmd>e $MYVIMRC<cr>

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

let g:execprg = {
	\ 'vim': { -> execute('source %') },
	\ 'html': { -> jobstart(['firefox', '--new-window', 'file://' . expand('%:p')]) },
	\ 'rmd': 'xdg-open /tmp/preview.pdf',
	\ 'pandoc': 'xdg-open /tmp/preview.pdf',
	\ 'tex': { -> jobstart(['xdg-open', expand("%:r") . ".pdf"]) },
	\ 'dot': 'xdg-open /tmp/preview.pdf',
	\ }

call sl#enable()

" Stop plugins from pollution leader
let mapleader = "\\"
