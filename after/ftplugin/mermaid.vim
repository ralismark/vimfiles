let &l:commentstring = "%%%% %s"
let &l:makeprg = 'nix shell nixpkgs\#nodePackages.mermaid-cli -c mmdc -i "%" -o ' . g:pdf_out . ' -c <(echo ''{"themeCSS":".extension { fill: white !important; }"}'') $*'
