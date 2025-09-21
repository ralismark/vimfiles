local augroup = require"vimrc".augroup()

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "BufWritePost" }, {
	group = augroup,
	desc = "autochdir",
	callback = function()
		if vim.o.buftype == "" then
			vim.cmd [[silent! lcd %:p:h]]
		end
	end,
})

vim.api.nvim_create_autocmd({ "TermRequest" }, {
	group = augroup,
	desc = "OSC 7 dir change request",
	callback = function(ev)
		if string.sub(ev.data.sequence, 1, 4) == "\x1b]7;" then
			local dir = string.gsub(ev.data.sequence, '\x1b]7;file://[^/]*', '')
			vim.api.nvim_buf_call(ev.buf, function()
				vim.cmd.lcd(dir)
			end)
		end
	end
})
