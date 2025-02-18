local M = {}

M.config = {
	model = "fireworks::v1::starcoder",
}

---@param results vim.SystemCompleted
local function handle_syscomplete(results)
	if results.signal ~= 0 then
		error(string.format("curl exited with signal %d", results.signal))
	elseif results.code ~= 0 then
		error(string.format("curl exited with code %d\n%s", results.code, results.stderr))
	else
		local http_code = tonumber(results.stderr)
		if http_code ~= 200 then
			error(string.format("SG request failed with HTTP code %d\n%s", http_code, results.stdout))
		end
		local response = vim.json.decode(results.stdout)
		return response
	end
end

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


-- See https://github.com/sourcegraph/openapi for docs
function M.request(method, path, data, cb)
	if vim.env.SRC_ENDPOINT == nil or vim.env.SRC_ACCESS_TOKEN == nil then
		error("SRC_ENDPOINT and SRC_ACCESS_TOKEN must be set")
	end

	local cmd = {
		"curl",
		"--silent", "--show-error",
		"--no-buffer",

		"-X", method,
		vim.env.SRC_ENDPOINT .. path,
		"-H", "Authorization: token ".. vim.env.SRC_ACCESS_TOKEN,
		"-H", "X-Requested-With: curl 0",
		"-H", "Accept: application/json",
		"--write-out", "%{stderr}%{http_code}",
		"--data", "@-", -- read body from stdin
	}

	local p = vim.system(cmd, {
		stdin = data and vim.json.encode(data)
	}, cb)
	return p
end

function M.models()
	local response = M.request("GET", "/.api/llm/models"):wait()
	return vim.json.decode(response.stdout)
end

-- Completion -----------------------------------------------------------------

---@class PromptParams
---@field filename string
---@field prefix string
---@field suffix string

---@class ModelConfig
--- Description of how to interface with a model.
--- Also see ClientSideModelConfigOpenAICompatible in the OpenAPI schema.
---
---@field contextSizeHintPrefixCharacters integer The maximum length of the document prefix (text before the cursor) to include, in characters.
---@field contextSizeHintSuffixCharacters integer The maximum length of the document suffix (text after the cursor) to include, in characters.
---
---@field stopSequences string[] List of stop sequences to use for this model.
---@field autoCompleteMultilineMaxTokens number
---@field autoCompleteTopK? number
---@field autoCompleteTopP? number
---@field autoCompleteTemperature? number
---
---@field format_prompt fun(params: PromptParams): string Generate the request body

---@type table<string, ModelConfig>
local models = {
	["fireworks::v1::starcoder"] = require "cody.models.starcoder",
}

M.cmp = {}

function M.cmp:is_available()
	return not not (
		vim.env.SRC_ENDPOINT
		and vim.env.SRC_ACCESS_TOKEN
		and models[M.config.model]
	)
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

	---@type ModelConfig
	local mc = models[M.config.model]
	if not mc then
		return
	end

	-- Get max number of lines including + before, as long as it is under the prefix limit.
	local prefix_start_line = math.max(vim.fn.byte2line(vim.fn.line2byte(linenr + 1) - mc.contextSizeHintPrefixCharacters), 0) + 1
	local prefix = vim.api.nvim_buf_get_text(0, prefix_start_line - 1, 0, linenr - 1, colnr - 1, {})

	-- Get max number of lines including + after, as long as it is under the suffix limit.
	local suffix_end_line = vim.fn.byte2line(vim.fn.line2byte(linenr) + mc.contextSizeHintSuffixCharacters)
	if 0 <= suffix_end_line and suffix_end_line < linenr then
		suffix_end_line = linenr
	end
	local suffix = vim.api.nvim_buf_get_text(0, linenr - 1, colnr - 1, suffix_end_line, -1, {})

	-- Generate request body
	local body = {
		model = M.config.model,

		stopSequences = mc.stopSequences,
		maxTokensToSample = mc.autoCompleteMultilineMaxTokens,
		topK = mc.autoCompleteTopK,
		topP = mc.autoCompleteTopP,
		temperature = mc.autoCompleteTemperature,

		messages = {
			{
				role = "user",
				content = mc.format_prompt({
					filename = vim.api.nvim_buf_get_name(0),
					prefix = table.concat(prefix, "\n"),
					suffix = table.concat(suffix, "\n"),
				}),
			}
		},
	}

	M.request("POST", "/.api/completions/code", body,
		function(response)
			local data = handle_syscomplete(response)
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
