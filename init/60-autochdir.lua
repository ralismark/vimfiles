vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "BufWritePost" }, {
	group = rc.augroup,
	desc = "autochdir",
	callback = function()
		if vim.o.buftype == "" then
			vim.cmd [[silent! lcd %:p:h]]
		end
	end,
})
