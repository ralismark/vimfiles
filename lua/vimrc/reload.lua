local M = {}

-- Try to convert an absolute path into its corresponding module name.
-- @param path string Path to resolve into a module
-- @return string|nil
function M.module_from_path(path)
	if path:sub(-4) ~= ".lua" then
		return nil
	end

	for _, rtp in ipairs(vim.api.nvim_list_runtime_paths()) do
		local root = rtp .. "/lua/"
		if path:sub(1, #root) == root then
			local rel = path:sub(#root + 1, -5):gsub("/", ".")
			return rel
		end
	end

	return nil
end

return M
