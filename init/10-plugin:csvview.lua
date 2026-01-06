local augroup = require"vimrc".augroup()

require "csvview".setup {
}

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup,
	pattern = { "csv", "tsv" },
	desc = "enable csvview",
	callback = function()
		require "csvview".enable()
	end,
})
