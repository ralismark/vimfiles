vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = rc.augroup,
	desc = "set foldmethod=marker if foldmarker in document",
	callback = function()
		-- check if foldmethod has already been set here
		local verbose = vim.api.nvim_exec2("verbose set foldmethod?", { output = true }).output
		local reason = vim.split(verbose, "\n")[2]
		if reason ~= nil and vim.trim(reason) ~= "Last set from Lua" then
			return
		end

		local marker = vim.split(vim.wo.foldmarker, ",")[1]
		local pat = "\\C\\V" .. marker:gsub("\\", "\\\\")
		local hasmarker = vim.fn.search(pat, "nw") > 0
		if hasmarker then
			vim.wo.foldmethod = "marker"
		end
	end,
})
