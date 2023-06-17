vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = rc.augroup,
	desc = "vim.diagnostic.open_float",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

require "vimrc.diagnostic".setup {
}

-- TODO: Switch to using numhl when neovim v0.7 gets released <2022-03-18>
--       This is blocked on neovim/neovim#16914 'don't put empty sign text in line number column'
vim.cmd([[
sign define DiagnosticSignError text=✕ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn  text=▲ texthl=DiagnosticSignWarn  linehl= numhl=
sign define DiagnosticSignInfo  text=◆ texthl=DiagnosticSignInfo  linehl= numhl=
sign define DiagnosticSignHint  text=🞶 texthl=DiagnosticSignHint  linehl= numhl=
]])

