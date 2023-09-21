-- word formatting
vim.opt.textwidth = 0
vim.opt.formatoptions = "tcro/qlnj"
vim.opt.joinspaces = false

-- kernel style indents
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.expandtab = false
vim.opt.smarttab = true

vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.preserveindent = true

-- ft=vim line continuation indent
vim.g.vim_indent_cont = 0

-- c indent
vim.opt.cinoptions = {
	"(s", -- Contents of unclosed parentheses
	":0", -- Case labels
	"Ls", -- Jump labels
	"u0",
	"U0", -- Do not ignore when parens are first char in line
	"b0", -- Align break with case
	"g0", -- Scope labels
	"l1", -- No align with label
	"t0", -- Function return type declarations
}
