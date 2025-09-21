local augroup = require"vimrc".augroup()

vim.api.nvim_create_autocmd("BufNewFile", {
	group = augroup,
	pattern = "*",
	desc = "vimrc.skeletons",
	callback = (require "vimrc.skeletons").expand,
})
