---@type cody.ModelConfig
local M = {}

M.stopSequences = {
	"\n\n",
	"<｜fim▁begin｜>",
	"<｜fim▁hole｜>",
	"<｜fim▁end｜>, <|eos_token|>"
}

-- params
M.autoCompleteTemperature = 0.6
M.autoCompleteTopK = 30
M.autoCompleteTopP = 0.2
M.autoCompleteMultilineMaxTokens = 256

M.contextTokens = 2048

function M.format_prompt(params)
	return table.concat({
		"#", params.path, "\n",
		"<｜fim▁begin｜>", params.prefix,
		"<｜fim▁hole｜>", params.suffix,
		"<｜fim▁end｜>",
	})
end

return M
