vim.opt.termguicolors = false
vim.cmd("colorscheme duality")

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	group = rc.augroup,
	desc = "colorscheme patches",
	callback = function()
		vim.cmd [[
			hi pandocHTMLComment ctermbg=245 ctermfg=192 cterm=none
		]]
	end,
})

vim.api.nvim_create_autocmd({ "Syntax" }, {
	group = rc.augroup,
	desc = "syntax patches",
	callback = function()
		vim.cmd [[
			syntax match ConflictMarker containedin=ALL /^\(<<<<<<<\|=======\||||||||\|>>>>>>>\).*/
			hi def link ConflictMarker Error

			" PEP 350 Codetags (https://www.python.org/dev/peps/pep-0350/)
			syn keyword Codetag contained containedin=.*Comment.*
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
				\ SAFETY
			hi def link Codetag Todo
		]]
	end,
})

-- copy from terminal
local colours = require "vimrc.colours"
vim.g.terminal_color_0  = colours.dim_black
vim.g.terminal_color_1  = colours.dim_red
vim.g.terminal_color_2  = colours.dim_green
vim.g.terminal_color_3  = colours.dim_yellow
vim.g.terminal_color_4  = colours.dim_blue
vim.g.terminal_color_5  = colours.dim_magenta
vim.g.terminal_color_6  = colours.dim_cyan
vim.g.terminal_color_7  = colours.dim_white
vim.g.terminal_color_8  = colours.bright_black
vim.g.terminal_color_9  = colours.bright_red
vim.g.terminal_color_10 = colours.bright_green
vim.g.terminal_color_11 = colours.bright_yellow
vim.g.terminal_color_12 = colours.bright_blue
vim.g.terminal_color_13 = colours.bright_magenta
vim.g.terminal_color_14 = colours.bright_cyan
vim.g.terminal_color_15 = colours.bright_white
