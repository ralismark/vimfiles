vim.api.nvim_create_autocmd("BufNewFile", {
	group = rc.augroup,
	pattern = "*",
	desc = "vimrc.skeletons",
	callback = (require "vimrc.skeletons").expand,
})
