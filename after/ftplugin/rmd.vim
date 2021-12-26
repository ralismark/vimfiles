" RMarkdown *is* pandoc, but compiled differently
runtime! ftplugin/pandoc.vim ftplugin/pandoc_*.vim ftplugin/pandoc/*.vim

let &l:makeprg = 'Rscript -e "rmarkdown::render(''%'', output_file=''' . g:pdf_out . ''', output_format=''pdf_document'')"'
let b:undo_ftplugin .= '|setl makeprg<'
