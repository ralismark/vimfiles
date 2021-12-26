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
Plug 'ray-x/lsp_signature.nvim'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" UI
Plug 'ayu-theme/ayu-vim'
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'

" Workflow/Misc
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'ralismark/vim-recover'
Plug 'chrisbra/Colorizer'
Plug 'rafcamlet/nvim-luapad'

" Syntax/Language
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
let g:polyglot_disabled = ["latex"]
Plug 'sheerun/vim-polyglot'

" Editing
let itab#disable_maps = 0 | Plug 'ralismark/itab'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'thinca/vim-textobj-between'
Plug 'tomtom/tcomment_vim'

" System
Plug '/usr/share/vim/vimfiles'

Plug g:configdir . '/bundle/vimrc'
" Plug g:configdir . '/bundle/isabelle'

call plug#end()

" Neovim Native LSP {{{2

lua << EOF
local lspconfig = require "lspconfig"
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require "lsp_signature".setup({
	floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
	doc_lines = 0,
	handler_opts = {
		border = "none",
	},

	hint_enable = false, -- virtual hint enable
	hint_prefix = "◇ ",
	hint_scheme = "LspParameterHint",
})

-- lspconfig.efm.setup {
-- 	cmd = { "efm-langserver", "-c", "/home/timmy/.config/nvim/efm.yaml" },
-- }
lspconfig.pylsp.setup {
	capabilities = capabilities,
	cmd = { "pyls" },
	settings = {
		pyls = {
			plugins = {
				pylint = { enabled = true },
				yapf = { enabled = false },
			},
		},
	},
}
lspconfig.rust_analyzer.setup {
	capabilities = capabilities,
}
lspconfig.clangd.setup {
	capabilities = capabilities,
}

-- Isabelle configs
-- require "isabelle"
-- lspconfig.isabelle.setup {}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		focusable = false
	}
)

EOF

command! -nargs=0 LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients()) <bar> let g:lsp_enable = 0

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<cr>

sign define DiagnosticSignError text=✕ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn  text=! texthl=DiagnosticSignWarn  linehl= numhl=
sign define DiagnosticSignInfo  text=🞶 texthl=DiagnosticSignInfo  linehl= numhl=
sign define DiagnosticSignHint  text=? texthl=DiagnosticSignHint  linehl= numhl=

let g:lsp_enable = 1

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
		\ | hi LspParameterHint cterm=italic ctermfg=yellow guifg=yellow 

	au CursorHold * silent lua vim.diagnostic.open_float(nil, { focusable = false })

	" au BufWritePre * silent! lua vim.lsp.buf.formatting_sync(nil, 1000)

	"au BufEnter * if g:lsp_enable | call luaeval("require'completion'.on_attach()") | endif

augroup END

" Autocomplete (nvim-cmp) {{{2

lua << EOF
local cmp = require "cmp"

cmp.setup({
	mapping = {
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
	experimetnal = {
		native_menu = true,
	},
	formatting = {
	},
	completion = {
	},
})

EOF

inoremap <expr> <Plug>(cmp-complete) luaeval("require'cmp'.complete()") ? "" : ""

imap <silent><expr> <tab>
	\ luaeval("require'cmp'.visible()") ? "\<c-n>"
	\ : (col('.') > 1 && getline('.')[col('.') - 2] !~ '\s') ? "\<Plug>(cmp-complete)"
	\ : "\<Plug>ItabTab"
inoremap <expr> <s-tab> luaeval("require'cmp'.visible()") ? "\<c-p>" : "\t"

" Goyo {{{2

let g:goyo_width = 90

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

let g:python3_host_prog = '/usr/bin/python3'
let g:man_hardwrap = 0

set nofixeol " Don't want to keep updating eol in random files

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
set fillchars=eob:\ ,vert:│,fold:─,stl:─,stlnc:─,foldopen:╒,foldclose:═

" Line numbers
set number relativenumber
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

function! SortMotion(motion) " {{{2
	if a:motion ==# "line"
		'[,']sort
	elseif a:motion ==# "\<c-v>"
		let regex = '/\%' . virtcol("'<") . 'v.*\%<' . (virtcol("'>") + 1) . 'v/'
		exec "normal! \<esc>"
		exec "'<,'>sort" regex
	elseif a:motion ==# "V" || a:motion ==# "v"
		exec "normal! \<esc>"
		'<,'>sort
	endif
endfunction

function! GetSynClass() " {{{2
	return map(synstack(line('.'), col('.')), {k,v -> synIDattr(v, "name")})
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
		\ | hi def link Codetags Todo

" FAQ
augroup END

" Bindings {{{1

" Commands {{{2

command! -nargs=0 W exec "w !pkexec tee %:p >/dev/null" | setl nomod
" This, for some reason, doesn't work if you put it in a function
command! -nargs=+ Keepview let s:view_save = winsaveview() | exec <q-args> | call winrestview(s:view_save)
command! -nargs=+ -complete=file Fork call jobstart(<q-args>)

" Misc {{{2

NXnoremap <left> zh
NXnoremap <right> zl
NXnoremap <up> <c-y>
NXnoremap <down> <c-e>

" Insert ISO 8601 date
noremap! <c-r><c-d> <c-r>=strftime("%Y-%m-%d")<cr>
" Insert name of tempfile
noremap! <c-r><c-t> <c-r>=tempname()<cr>

inoremap <c-e> <c-o><c-e>
inoremap <c-y> <c-o><c-y>

" better binds
noremap ; :
noremap , ;
noremap ' `
noremap <silent> <expr> 0 &wrap ? 'g0' : '0'
map <expr> <return>
	\ or(&buftype == 'help', expand("%:p") =~ '^man://') ? "\<c-]>"
	\ : &buftype == 'quickfix' ? "\<CR>"
	\ : "@q"
command! -nargs=0 -range=% KillWhitespace Keepview <line1>,<line2>s/[\x0d[:space:]]\+$//e | nohl
NXnoremap <expr> G &wrap ? "G$g0" : "G"
noremap <s-return> @w
nnoremap Y y$
nnoremap g= 1z=
xnoremap <expr> p '"' . v:register . 'pgv' . '"' . v:register . 'y'

" sort motion
nnoremap gs <cmd>set operatorfunc=SortMotion<cr>g@
nnoremap gss <nop>
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
nnoremap <leader>x <cmd>call v:lua.exec_current()<cr>
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
		vim.api.cmd("luafile %")
	end,

	html = function()
		local path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "firefox", "--new-window", "file://" .. path })
	end,
	tex = function()
		local stem = vim.fn.expand("%:r")
		vim.fn.jobstart({ "xdg-open", stem .. ".pdf" })
	end,

	rmd = open_pdf_out,
	pandoc = open_pdf_out,
	dot = open_pdf_out,
}
EOF

call sl#enable()

" HACK for fixing colorscheme
hi diffAdded ctermfg=green
hi diffRemoved ctermfg=red

" Stop plugins from pollution leader
let mapleader = "\\"
