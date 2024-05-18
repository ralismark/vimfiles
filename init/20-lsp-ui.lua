vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = rc.augroup,
	desc = "vim.diagnostic.open_float",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

require "vimrc.diagnostic".setup {
}

vim.cmd([[
sign define DiagnosticSignHint  text=🞶 texthl=DiagnosticSignHint  linehl= numhl=
sign define DiagnosticSignInfo  text=◆ texthl=DiagnosticSignInfo  linehl= numhl=
sign define DiagnosticSignWarn  text=▲ texthl=DiagnosticSignWarn  linehl= numhl=
sign define DiagnosticSignError text=✕ texthl=DiagnosticSignError linehl= numhl=
]])


-- Disable semantic highlights (see :help lsp-semantic-highlight)
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	group = rc.augroup,
	desc = "disable semantic highlight",
	callback = function()
		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end,
})
