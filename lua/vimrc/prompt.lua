local M = {}

local function evaluate(body)
	local loaded = {loadstring(string.format("return %s", body))}
	if not loaded[1] then
		return { err = loaded[2]}
	end

	local result = {pcall(loaded[1])}
	local status = table.remove(result, 1)
	if not status then
		return {err = result[1]}
	end

	-- return all but first element
	return result
end

function M.prompt()
	vim.cmd "new"
	local buf = vim.fn.bufnr()
	vim.bo.buftype = "prompt"

	-- local p = vim.system({ "/bin/sh" }, {
	-- 	stdin = true,
	-- 	stdout = function(err, data)
	-- 		print(data)
	-- 		vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, vim.split(data, "\n"))
	-- 	end,
	-- 	stderr = function(err, data)
	-- 		print(data)
	-- 		vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, vim.split(data, "\n"))
	-- 	end,
	-- }, function (out)
	-- 	print("done", vim.inspect(out))
	-- end)

	vim.fn.prompt_setcallback(buf, function(body)
		local rets = evaluate(body)

		if rets.err ~= nil then
			vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, {"", "! "})
			vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, vim.split(rets.err, "\n"))
		else
			for _, ret in ipairs(rets) do
				local text = vim.inspect(ret)
				vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, {"", ""})
				vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, vim.split(text, "\n"))
			end
		end

		vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, {"", ""})
	end)
	vim.fn.prompt_setprompt(buf, ">>> ")
	vim.cmd "startinsert"
end

return M
