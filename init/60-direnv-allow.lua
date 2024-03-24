vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = {".envrc"},
	group = rc.augroup,
	desc = "direnv allow after saving .envrc",
	callback = function(ev)
		vim.fn.system({ "direnv", "allow", ev.file })
	end,
})
