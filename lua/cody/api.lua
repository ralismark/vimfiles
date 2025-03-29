local M = {}

--[[
		stdout = function(err, data)
			assert(err == nil, err)
			if data == nil then
				assert(buffer == "", "remaining data: " .. vim.inspect(buffer))
				return
			end

			buffer = buffer .. data
			while true do
				local _, finish, eventType, eventData = buffer:find(
					"^event: (%a*)\ndata: ([^\n]*)\n\n"
				)
				if finish == nil then
					break
				end

				onevent(eventType, vim.json.decode(eventData))

				buffer = buffer:sub(finish+1)
			end
		end,
]]

---@param context string
---@param results vim.SystemCompleted
local function handle_syscomplete(context, results)
	if results.signal ~= 0 then
		error(string.format(
			"cody: %s: curl exited with signal %s",
			context,
			results.signal
		))
	elseif results.code ~= 0 then
		error(string.format(
			"cody: %s: curl exited with code %s\n%s",
			context,
			results.code,
			results.stderr
		))
	else
		local metadata = vim.json.decode(results.stderr)
		local http_code = metadata.http_code

		if http_code == 200 then
			return vim.json.decode(results.stdout)
		else
			error(string.format(
				"cody: %s failed with HTTP code %s\n%s\n%s",
				context,
				http_code,
				vim.inspect(metadata.headers),
				results.stdout
			))
		end
	end
end

---@class cody.ApiResponse
---@field wait fun(): table

--- See https://github.com/sourcegraph/openapi for docs
---@return cody.ApiResponse
function M.request(method, path, data, cb)
	if vim.env.SRC_ENDPOINT == nil or vim.env.SRC_ACCESS_TOKEN == nil then
		error("SRC_ENDPOINT and SRC_ACCESS_TOKEN must be set")
	end

	local cmd = {
		"curl",
		"--silent", "--show-error",
		"--no-buffer",
		"-L",

		"-X", method,
		vim.env.SRC_ENDPOINT .. path,
		"-H", "Authorization: token ".. vim.env.SRC_ACCESS_TOKEN,
		"-H", "X-Requested-With: curl 0",
		"-H", "Accept: application/json",
		"--write-out", [[%{stderr}{"http_code":%{http_code},"headers":%{header_json}}]],
		"--data", "@-", -- read body from stdin
	}

	local context = string.format("%s %s", method, vim.env.SRC_ENDPOINT .. path)

	local p = vim.system(
		cmd,
		{
			stdin = data and vim.json.encode(data)
		},
		cb and function(results) cb(handle_syscomplete(context, results)) end
	)

	local old_wait = p.wait
	p.wait = function()
		return handle_syscomplete(context, old_wait(p))
	end

	return p
end

return M
