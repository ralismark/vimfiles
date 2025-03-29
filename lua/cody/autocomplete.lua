local api = require "cody.api"
local config = require "cody.config"

local M = {}

---@return cody.PromptParams
local function gather_context(buf, linenr, colnr, tokens)
	local path = vim.api.nvim_buf_get_name(buf)
	local context_bytes = tokens * config.chars_per_token * config.autocomplete.context_proportion

	-- Context around the cursor
	local affix_size = math.floor(context_bytes / 2)

	-- Get max number of lines including + before, as long as it is under the prefix limit.
	local prefix_start_line = math.max(vim.fn.byte2line(vim.fn.line2byte(linenr + 1) - affix_size), 0) + 1
	local prefix = vim.api.nvim_buf_get_text(buf, prefix_start_line - 1, 0, linenr - 1, colnr - 1, {})

	-- Get max number of lines including + after, as long as it is under the suffix limit.
	local suffix_end_line = vim.fn.byte2line(vim.fn.line2byte(linenr) + affix_size)
	if 0 <= suffix_end_line and suffix_end_line < linenr then
		suffix_end_line = linenr
	end
	local suffix = vim.api.nvim_buf_get_text(buf, linenr - 1, colnr - 1, suffix_end_line, -1, {})

	return {
		path = path,
		prefix = table.concat(prefix, "\n"),
		suffix = table.concat(suffix, "\n"),
		context = {},
	}
end

---@return string|nil name
---@return cody.ModelConfig|nil mc
function M.get_model(setdefault)
	if not (vim.env.SRC_ENDPOINT and vim.env.SRC_ACCESS_TOKEN and config.autocomplete.enable) then
		return nil, nil
	end

	if setdefault and config.autocomplete.model == nil then
		local req = api.request("GET", "/.api/modelconfig/supported-models.json")
		local ok, response = pcall(req.wait, req)
		if ok and response.defaultModels and response.defaultModels.codeCompletion then
			config.autocomplete.model = response.defaultModels.codeCompletion
		else
			config.autocomplete.model = "(could not load default)"
		end
	end

	local mc = (require "cody.models").models[config.autocomplete.model]
	if not mc then
		return nil, nil
	end

	return config.autocomplete.model, mc
end

function M:is_available()
	local name, mc = M.get_model(false)
	return mc ~= nil
end

function M:get_trigger_characters()
	return { "@", ".", "(", "{", " " }
end

function M:get_keyword_pattern()
	-- Add dot to existing keyword characters (\k).
	return [[\%(\k\|\.\)\+]]
end

---@param params cmp.SourceCompletionApiParams
---@param callback function(response: lsp.CompletionResponse)
function M:complete(params, callback)
	local linenr = params.context.cursor.row
	local colnr = params.context.cursor.col

	local name, mc = M.get_model(true)
	---@type cody.ModelConfig|nil
	if not mc then
		return
	end

	-- Generate request body
	local prompt_params = gather_context(params.context.bufnr, linenr, colnr, mc.contextTokens)
	local body = {
		model = name,

		stopSequences = mc.stopSequences,
		maxTokensToSample = mc.autoCompleteMultilineMaxTokens,
		topK = mc.autoCompleteTopK,
		topP = mc.autoCompleteTopP,
		temperature = mc.autoCompleteTemperature,

		messages = {
			{
				role = "user",
				content = mc.format_prompt(prompt_params),
			}
		},
	}

	api.request("POST", "/.api/completions/code", body,
		function(response)
			local here = {
				line = params.context.cursor.row - 1,
				character = params.context.cursor.col - 1,
			}

			if response.completion then
				callback({
					items = {
						{
							label = params.context.cursor_before_line:sub(params.offset) .. response.completion,
						},
					},
					isIncomplete = false,
				})
			end
		end
	)
end

---@module "cmp"
local cmp, cmp_ok
cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
	-- unregister previous cmp
	for _, source in pairs(cmp.get_registered_sources()) do
		if source.name == "cody" then
			cmp.unregister_source(source.id)
		end
	end

	cmp.register_source("cody", M)
end

return M
