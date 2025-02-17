local M = {}

---@class Repo
---@field root? string The root directory of the repo
---@field url? string The URL of the repo host
---@field commit_url_format? string
---@field file_url_format? string
---@field range_url_format? string
M.Repo = {}
setmetatable(M.Repo, {
	__call = function(t, ...)
		return t:new(...)
	end
})

--- Get information about the repo
function M.Repo:new(path)
	local data = {}
	setmetatable(data, {
		__metatable = self,
		__index = self,
	})

	local gitdir = vim.fs.find(".git", { path = path, upward = true })
	if #gitdir == 1 then
		data.root = vim.fs.dirname(gitdir[1])

		local remote = vim.fn.system({ "git", "remote", "get-url", "origin" }):gsub("\n$", "")
		local commit_or_branch = vim.fn.system("git symbolic-ref -q --short HEAD 2>/dev/null || git rev-parse HEAD"):gsub("\n$", "")

		local m_github = remote:match("%S*@github.com:(.*)") or remote:match("https?://github.com/(.*)")
		if m_github ~= nil then
			data.url = "https://github.com/" .. m_github:gsub(".git$", "")
			data.commit_url_format = data.url .. "/commit/%s"
			data.file_url_format = data.url .. "/blob/" .. commit_or_branch .. "/%s"
		end

		-- TODO other repo hosts?
	end

	return data
end

function M.Repo:relpath(path)
	if not self.root then
		return nil
	end

	if not path then
		path = vim.fn.expand("%")
	end

	return vim.fn.system({ "realpath", "--relative-to=" .. self.root, "--", path }):gsub("\n$", "")
end

---@param path? string File path to create URL for. Defaults to buffer path.
function M.Repo:file_url(path)
	if not self.file_url_format then
		return nil
	end

	return self.file_url_format:format(self:relpath(path))
end

--- Get information about the repo
function M.repo()
	local data = {}

	local gitdir = vim.fs.find(".git", { upward = true })
	if #gitdir == 0 then
		data.root = vim.fs.dirname(gitdir[1])
		-- TODO support other repo types in future?

		local remote = vim.fn.system({ "git", "remote", "get-url", "origin" }):gsub("\n$", "")
		local commit_or_branch = vim.fn.system("git symbolic-ref -q --short HEAD 2>/dev/null || git rev-parse HEAD"):gsub("\n$", "")

		local m_github = remote:match("%S*@github.com:(.*)") or remote:match("https?://github.com/(.*)")
		if m_github ~= nil then
			data.url = "https://github.com/" .. m_github:gsub(".git$", "")
			data.commit_url_format = data.url .. "/commit/%s"
			data.file_url_format = data.url .. "/blob/" .. commit_or_branch .. "/%s"
		end
	end

	return data
end

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
		if key ~= "" and key ~= nil then
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
		return os.date("%d %b %Y", data["author-time"]) .. " ∙ " .. data.author .. " ∙ " .. data.summary
	end
end

return M
