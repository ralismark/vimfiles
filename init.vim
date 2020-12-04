" vim: set foldmethod=marker:

let g:configdir = fnamemodify($MYVIMRC, ':p:h')

" Plugins {{{1

command! -nargs=+ NXnoremap  nnoremap <args>|xnoremap <args>
command! -nargs=+ NXmap      nmap <args>|xmap <args>

if &loadplugins

" Vim-Plug {{{2

call plug#begin(g:configdir . '/plugged')

" Frameworks
Plug 'tpope/vim-repeat'
Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/diagnostics-nvim'
Plug 'nvim-lua/completion-nvim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" UI
Plug 'ayu-theme/ayu-vim'
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'

" Workflow/Misc
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'ralismark/vim-recover'
Plug 'chrisbra/Colorizer'

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
" Plug 'ncm2/ncm2'
" some completion sources
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Plug 'ncm2/ncm2-ultisnips'

Plug 'sirver/ultisnips'

" System
Plug '/usr/share/vim/vimfiles'

" Plug g:configdir . '/bundle/etypehead'
Plug g:configdir . '/bundle/vimrc'

call plug#end()

" Neovim Native LSP {{{2

lua << EOF
local nvim_lsp = require 'nvim_lsp'

nvim_lsp.efm.setup {
	cmd = { "efm-langserver", "-c", "/home/timmy/.config/nvim/efm.yaml" },
}
nvim_lsp.pyls.setup {
	settings = {
		pyls = {
			plugins = {
				pylint = { enabled = true },
				yapf = { enabled = false },
			},
		},
	},
}
nvim_lsp.rls.setup {
	settings = { },
}
nvim_lsp.clangd.setup {}
EOF

command! -nargs=0 LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients())

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<cr>

sign define LspDiagnosticsErrorSign       text=✕  texthl=LspDiagnosticsErrorSign       linehl= numhl=
sign define LspDiagnosticsWarningSign     text=⚠️  texthl=LspDiagnosticsWarningSign     linehl= numhl=
sign define LspDiagnosticsInformationSign text=🞶  texthl=LspDiagnosticsInformationSign linehl= numhl=
sign define LspDiagnosticsHintSign        text=💡 texthl=LspDiagnosticsHintSign        linehl= numhl=

augroup vimrc_lsp
	au!
	au ColorScheme *
		\ hi LspDiagnosticsVirtualText cterm=italic ctermfg=yellow guifg=yellow
		\ | hi LspDiagnosticsErrorSign ctermfg=white ctermbg=red guifg=white guibg=red
		\ | hi LspDiagnosticsWarningSign ctermfg=black ctermbg=yellow guifg=black guibg=yellow
		\ | hi LspDiagnosticsInformationSign ctermfg=yellow guifg=yellow
		\ | hi link LspDiagnosticsError LspDiagnosticsVirtualText
		\ | hi link LspDiagnosticsWarning LspDiagnosticsVirtualText
		\ | hi link LspDiagnosticsInformation LspDiagnosticsVirtualText
		\ | hi link LspDiagnosticsHint LspDiagnosticsVirtualText

	au CursorHold * silent lua vim.lsp.util.show_line_diagnostics()

	" au BufWritePre * silent! lua vim.lsp.buf.formatting_sync(nil, 1000)

	au BufEnter * lua require'completion'.on_attach()

augroup END

" " Tab completion
imap <silent><expr> <tab>
	\ pumvisible() ? "\<c-n>"
	\ : (col('.') < 2 <bar><bar> getline('.')[col('.') - 2] =~ '\s') ? "\<Plug>ItabTab"
	\ : "\<Plug>(completion_trigger)"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\t"

" COC {{{2

" let g:coc_global_extensions = [ 'coc-clangd', 'coc-rls', 'coc-json', 'coc-diagnostic' ]
"
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"

" Goyo {{{2

let g:goyo_width = 90

" vim-polyglot {{{2

let g:polyglot_disabled = ["latex"]
let g:did_cpp_syntax_inits = 1
let g:vim_markdown_fenced_languages = ['jsw=javascript']

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

" Dispatch {{{2

let g:dispatch_no_maps = 1

endif

" Options {{{1

" Misc {{{2

" Use Ag if possible
if executable('rg')
	let &grepprg = "rg --vimgrep"
	set grepformat=%f:%l:%c:%m
elseif executable('ag')
	let &grepprg = "ag --nogroup --nocolor --column $*"
	set grepformat=%f:%l:%c%m
endif

set diffopt+=algorithm:patience,indent-heuristic
set updatetime=1000

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

function! SortMotion(motion) " {{{2
	if a:motion ==# "line"
		exec "'[,']sort"
	elseif a:motion ==# "\<c-v>"
		let cols = sort([ virtcol("v"), virtcol(".") ])
		let sel = sort([ line("v"), line(".") ])
		let regex = '/\%' . cols[0] . 'v.*\%<' . (cols[1] + 1) . 'v/'
		exec sel[0] . "," . sel[1] . "sort" regex
		normal! <esc>
	elseif a:motion ==# "V"
		let sel = sort([ line("v"), line(".") ])
		exec sel[0] . "," . sel[1] . "sort"
		normal! <esc>
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
xnoremap <expr> p '"' . v:register . 'pgv' . '"' . v:register . 'y'

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
nnoremap <leader>x <cmd>call ExecCurrent()<cr>
nnoremap <leader>m <cmd>Dispatch<cr>
nnoremap <leader>z <cmd>term<cr><cmd>startinsert<cr>

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
