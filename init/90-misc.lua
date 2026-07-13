require "editorconfig".properties.vim_ft = function(bufnr, val, opts)
	vim.bo[bufnr].filetype = val
end
