vim.opt.comments = {
	"s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:•"
}

-- word formatting
vim.opt.textwidth = 80 -- non-zero so that it's not dependent on window width
vim.opt.formatoptions = "ro/qnj" -- no tc to not wrap in insert mode
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
	":0", -- Case labels
	"Ls", -- Jump labels
	"b0", -- Align break with case
	"g0", -- Scope labels
	"l1", -- No align with label
	"t0", -- Function return type declarations
	-- indenting after unclosed parentheses
	"(s", -- Contents of unclosed parentheses
	"us",
	"Ws", -- contents of (...) are indented
	"U0", -- Do not ignore when parens are first char in line
	"m1", -- Closing ) lines up with start of line, not (
}
