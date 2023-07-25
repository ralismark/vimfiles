-- TODO what does this do <2023-06-25>
vim.g.did_cpp_syntax_inits = 1

vim.g.polyglot_disabled = {
	"latex", -- TODO why? <2023-06-25>
	"protobuf", -- TODO why? <2023-06-25>
	"sensible", -- this does shortmess+=A which breaks plugin:vim-recover
}
