local augroup = require"vimrc".augroup()

vim.api.nvim_create_user_command("GitLog", function(opts)
	local bufname = vim.api.nvim_buf_get_name(0)
	vim.cmd.new({
		mods = {
			vertical = opts.smods.vertical,
			split = opts.smods.split,
		}
	})
	vim.fn.jobstart(
		{ "git", "log", "-p", "--follow", "--", bufname },
		{ term = true }
	)
end, {
	nargs = 0,
	desc = "git log -p %",
})

-- TODO FileReadCmd and SourceCmd
vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
	group = augroup,
	pattern = { "*@*" },
	desc = "git show <ref>:<file>",
	callback = function(ev)
		local buf = vim.api.nvim_get_current_buf()

		if vim.uv.fs_stat(ev.match) then
			return -- exists
		end

		local done = false

		local path, ref = ev.match:match("(.*)@(.*)")
		local exit = vim.system(
			{ "git", "show", ref .. ":./" .. vim.fs.basename(path) },
			{
				cwd = vim.fs.dirname(path),
				stdout = vim.schedule_wrap(function(err, data)
					if data ~= nil then
						vim.api.nvim_buf_set_text(buf, -1, -1, -1, -1, vim.split(data, "\n"))
					else
						-- fix extra empty line at end
						vim.api.nvim_buf_set_lines(buf, -2, -1, true, {})
						done = true
					end
				end),
			}
		):wait()

		-- race conditions...
		vim.wait(1000, function() return done end)

		if exit.stderr ~= "" then
			vim.api.nvim_echo({{ exit.stderr  }}, true, { err = true })
			return
		end

		vim.bo[buf].modifiable = false
		vim.bo[buf].buftype = "nowrite"
		vim.bo[buf].bufhidden = "delete"

		-- filetype
		local ft, ftfunc = vim.filetype.match({ buf = buf, filename = path })
		if ft then
			vim.bo[buf].filetype = ft
		end
		if ftfunc then
			ftfunc(buf)
		end
	end,
})

vim.api.nvim_create_user_command("GitShow", function(opts)
	local commit = opts.fargs[1] or "HEAD"
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd.split({
		vim.api.nvim_buf_get_name(0) .. "@" .. commit,
		mods = {
			vertical = opts.smods.vertical,
			split = opts.smods.split,
		}
	})
	vim.api.nvim_win_set_cursor(0, cursor)
end, {
	nargs = "?",
	desc = "git show HEAD:%",
})

vim.keymap.set("n", "<leader>gd", function()
	vim.cmd.diffthis()
	vim.cmd.GitShow({ mods = { vertical = true } })
	vim.cmd.diffthis()
end)
