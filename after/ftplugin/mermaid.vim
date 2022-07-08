let &l:commentstring = "%%%% %s"
let &l:makeprg = 'mmdc -i "%" -o ' . g:pdf_out . ' -c <(echo ''{"themeCSS":".extension { fill: white !important; }"}'') $*'
