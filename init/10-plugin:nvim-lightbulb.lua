local augroup = require"vimrc".augroup()

require "nvim-lightbulb".setup {
	virtual_text = {
		enabled = true,
	},
	sign = {
		enabled = false,
		priority = 20,
	},
	autocmd = {
		enabled = false,
	},
}

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = augroup,
	desc = [[require"nvim-lightbulb".update_lightbulb()]],
	callback = function()
		require "nvim-lightbulb".update_lightbulb()
	end,
})
