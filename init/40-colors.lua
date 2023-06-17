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
