" Editing {{{1

" Completion
set completeopt=menu,menuone,noinsert,noselect
set complete=.,w,b,t

" Clipboard
set clipboard=unnamed,unnamedplus

" Formatting {{{1

" Word formatting
set textwidth=0
set formatoptions=tcro/qlnj
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

