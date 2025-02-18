local M = {}

function M.prompt()
	vim.cmd "new"
	local buf = vim.fn.bufnr()
	vim.bo.buftype = "prompt"

	local p = vim.system({ "/bin/sh" }, {
		stdin = true,
		stdout = function(err, data)
			print(data)
			vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, vim.split(data, "\n"))
		end,
		stderr = function(err, data)
			print(data)
			vim.api.nvim_buf_set_text(buf, -2, -1, -2, -1, vim.split(data, "\n"))
		end,
	}, function (out)
		print("done", vim.inspect(out))
	end)

	vim.fn.prompt_setcallback(buf, function(body)
		p:write(body)
	end)
	vim.fn.prompt_setinterrupt(buf, function()
		print("<interrupt>")
	end)
	vim.fn.prompt_setprompt(buf, ">>> ")
	vim.cmd "startinsert"
end

return M
