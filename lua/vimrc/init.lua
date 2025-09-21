local M = {}

-- Create augroup for caller's file
function M.augroup()
	local caller = debug.getinfo(2, "S")
	return vim.api.nvim_create_augroup(caller.source, {
		clear = true
	})
end

return M
