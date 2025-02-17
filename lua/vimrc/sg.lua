local curl = require "plenary.curl"

local M = {}

-- See https://github.com/sourcegraph/openapi for docs

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

function M.request(method, path, data, cb)
	if vim.env.SRC_ENDPOINT == nil or vim.env.SRC_ACCESS_TOKEN == nil then
		error("SRC_ENDPOINT and SRC_ACCESS_TOKEN must be set")
	end

	local cmd = {
		"curl",
		"--silent", "--show-error",
		"--fail", -- HTTP 400+ = exit code 23
		"--no-buffer",

		"-X", method,
		vim.env.SRC_ENDPOINT .. path,
		"-H", "Authorization: token ".. vim.env.SRC_ACCESS_TOKEN,
		"-H", "X-Requested-With: curl 0",
		"-H", "Accept: application/json",
		"--data", "@-", -- read body from stdin
	}

	local p = vim.system(cmd, {
		stdin = data and vim.json.encode(data)
		--stdout = parser
	}, cb)
	return p
end

function M.models()
	local response = M.request("GET", "/.api/llm/models"):wait()
	return vim.json.decode(response.stdout)
end

---@class PromptParams
---@field filename string
---@field prefix string
---@field suffix string

---@param params PromptParams
local function starcoder_helper(params)
	return {
		model = "fireworks::v1::starcoder",
		stopSequences = {
			'\n\n',
			'<fim_prefix>',
			'<fim_suffix>',
			'<fim_middle>',
			'<file_sep>',
			-- starchat
			'<|end|>',
			'<|endoftext|>',
		},
		maxTokensToSample = 256,
		temperature = 0.2,

		messages = {
			{
				role = "user",
				content = table.concat({
					"<filename>", params.filename,
					"<fim_prefix>", params.prefix,
					"<fim_suffix>", params.suffix,
					"<fim_middle>",
				}),
			}
		}
	}
end

local context_bytes = math.floor(2048 * 3.5 * 0.9 / 2)

-- function M.completion()
--	local cur = vim.api.nvim_win_get_cursor(0)
--
--	local prefix_start_line = math.max(vim.fn.byte2line(vim.fn.line2byte(cur[1] + 1) - context_bytes), 0) + 1
--	local prefix = vim.api.nvim_buf_get_text(0, prefix_start_line - 1, 0, cur[1] - 1, cur[2], {})
--
--	local suffix_end_line = vim.fn.byte2line(vim.fn.line2byte(cur[1]) + context_bytes)
--	if 0 <= suffix_end_line and suffix_end_line < cur[1] then
--		suffix_end_line = cur[1]
--	end
--	local suffix = vim.api.nvim_buf_get_text(0, cur[1] - 1, cur[2], suffix_end_line - 1, -1, {})
--
--	local response = M.request("POST", "/.api/completions/code",
--		starcoder_helper({
--			filename = vim.api.nvim_buf_get_name(0),
--			prefix = table.concat(prefix, "\n"),
--			suffix = table.concat(suffix, "\n"),
--		})
--	)
-- end

M.cmp = {}

function M.cmp:is_available()
	return not not (vim.env.SRC_ENDPOINT and vim.env.SRC_ACCESS_TOKEN)
end

function M.cmp:get_trigger_characters()
	return { "@", ".", "(", "{", " " }
end

function M.cmp:get_keyword_pattern()
	-- Add dot to existing keyword characters (\k).
	return [[\%(\k\|\.\)\+]]
end

---@param params cmp.SourceCompletionApiParams
---@param callback function(response: lsp.CompletionResponse)
function M.cmp:complete(params, callback)
	local linenr = params.context.cursor.row
	local colnr = params.context.cursor.col

	local prefix_start_line = math.max(vim.fn.byte2line(vim.fn.line2byte(linenr + 1) - context_bytes), 0) + 1
	local prefix = vim.api.nvim_buf_get_text(0, prefix_start_line - 1, 0, linenr - 1, colnr - 1, {})

	local suffix_end_line = vim.fn.byte2line(vim.fn.line2byte(linenr) + context_bytes)
	if 0 <= suffix_end_line and suffix_end_line < linenr then
		suffix_end_line = linenr
	end
	local suffix = vim.api.nvim_buf_get_text(0, linenr - 1, colnr - 1, suffix_end_line, -1, {})
	print(vim.inspect(suffix))

	M.request("POST", "/.api/completions/code",
		starcoder_helper({
			filename = vim.api.nvim_buf_get_name(0),
			prefix = table.concat(prefix, "\n"),
			suffix = table.concat(suffix, "\n"),
		}),
		function(response)
			local data = vim.json.decode(response.stdout)
			print(vim.inspect(data))
			local here = {
				line = params.context.cursor.row - 1,
				character = params.context.cursor.col - 1,
			}

			if data.completion then
				callback({
					items = {
						{
							label = params.context.cursor_before_line:sub(params.offset) .. data.completion,
						},
					},
					isIncomplete = false,
				})
			end
		end
	)
end

return M
