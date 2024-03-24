vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = rc.augroup,
	callback = function()
		-- IPC compatibility for nvr
		vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername
		-- no gutter
		vim.cmd [[
		setl nonumber
		setl norelativenumber
		]]
	end,
})
