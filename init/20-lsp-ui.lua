vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = rc.augroup,
	desc = "vim.diagnostic.open_float",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

-- require "vimrc.diagnostic".setup {
-- }

vim.diagnostic.config {
	severity_sort = true,

	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.HINT] = "🞶",
			[vim.diagnostic.severity.INFO] = "◆",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.ERROR] = "✕",
		},
	},
	virtual_text = {
	},
}


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
