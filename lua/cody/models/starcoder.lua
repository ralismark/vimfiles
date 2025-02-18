---@type ModelConfig
local M = {}

M.stopSequences = {
	'\n\n',
	'<fim_prefix>',
	'<fim_suffix>',
	'<fim_middle>',
	'<file_sep>',
	-- starchat
	'<|end|>',
	'<|endoftext|>',
}

-- params
M.autoCompleteMultilineMaxTokens = 256
M.autoCompleteTemperature = 0.2

local context_bytes = math.floor(2048 * 3.5 * 0.9 / 2)
M.contextSizeHintPrefixCharacters = context_bytes
M.contextSizeHintSuffixCharacters = context_bytes

function M.format_prompt(params)
	return table.concat({
		"<filename>", params.filename,
		"<fim_prefix>", params.prefix,
		"<fim_suffix>", params.suffix,
		"<fim_middle>",
	})
end

return M
