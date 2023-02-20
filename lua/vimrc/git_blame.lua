local M = {}

function M.blame_data()
	local result = vim.fn.systemlist({
			"git",
			"annotate",
			"--contents=-",
			"--porcelain",
			"-L" .. vim.fn.line(".") .. ",+1",
			"-M",
			vim.fn.expand("%"),
		}, vim.fn.bufnr("%"))
	local commit, origline, finalline = result[1]:match("([0-9a-f]*) ([0-9]*) ([0-9]*)")
	local props = {
		commit = commit,
		orig_lnum = tonumber(origline),
		final_lnum = tonumber(finalline),
	}
	for i = 2, #result do
		local key, value = result[i]:match("^([^ \t]*)%s(.*)$")
		if key ~= "" then
			props[key] = value
		end
	end
	return props
end

function M.blame()
	local data = M.blame_data()
	if data.commit == nil then
		return nil
	elseif data.commit == "0000000000000000000000000000000000000000" then
		return data.author
	else
		return data.commit:sub(0, 7) .. " ∙ " .. os.date("%d %b %Y", data["author-time"]) .. " ∙ " .. data.summary .. " ∙ " .. data.author
	end
end

return M
