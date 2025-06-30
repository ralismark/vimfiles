-- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
vim.keymap.del("n", "grn")
-- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
vim.keymap.del({ "n", "x" }, "gra")
-- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
vim.keymap.del("n", "grr")
-- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
vim.keymap.del("n", "gri")
