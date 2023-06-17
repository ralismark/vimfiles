require "nvim-lightbulb".setup {
	sign = {
		enabled = true,
		priority = 20,
	},
	autocmd = {
		enabled = false,
	},
}

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = rc.augroup,
	desc = [[require"nvim-lightbulb".update_lightbulb()]],
	callback = function()
		require "nvim-lightbulb".update_lightbulb()
	end,
})
