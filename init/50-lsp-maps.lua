vim.api.nvim_create_user_command("LspFormat", function()
	vim.lsp.buf.format {
	}
end, {
	nargs = 0,
	desc = "vim.lsp.buf.format()",
})

vim.api.nvim_create_user_command("LspRename", function(params)
	vim.lsp.buf.rename(params.args)
end, {
	nargs = 1,
	desc = "vim.lsp.buf.rename(...)",
})

-- TODO add a timeout to these <2022-07-10>
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "vim.lsp.buf.declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "vim.lsp.buf.implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "vim.lsp.buf.references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "vim.lsp.buf.hover" })
vim.keymap.set("n", "H", vim.lsp.buf.code_action, { desc = "vim.lsp.buf.code_action" })
vim.keymap.set("x", "H", vim.lsp.buf.range_code_action, { desc = "vim.lsp.buf.range_code_action" })
