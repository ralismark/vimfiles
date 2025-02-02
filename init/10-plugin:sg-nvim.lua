if vim.env.SRC_ENDPOINT == nil or vim.env.SRC_ACCESS_TOKEN == nil then
	-- print error
	vim.api.nvim_err_write("SRC_ENDPOINT and SRC_ACCESS_TOKEN must be set")
	return
end

vim.g.sg_provider = "fireworks"
vim.g.sg_model = "starcoder"

require "sg".setup {
	enable_cody = true,
	accept_tos = true,
	download_binaries = false,
}
