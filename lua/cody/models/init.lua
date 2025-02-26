local M = {}

---@class cody.PromptContext
---@field path string
---@field text string

---@class cody.PromptParams
---@field path string
---@field prefix string
---@field suffix string
---@field context cody.PromptContext[]

---@class cody.ModelConfig
--- Description of how to interface with a model.
--- Also see ClientSideModelConfigOpenAICompatible in the OpenAPI schema.
---
---@field contextTokens integer Maximum context window in tokens.
---
---@field stopSequences string[] List of stop sequences to use for this model.
---@field autoCompleteMultilineMaxTokens number Limit on output tokens.
---@field autoCompleteTopK? number topK parameter.
---@field autoCompleteTopP? number topP parameter.
---@field autoCompleteTemperature? number temperature parameter.
---
---@field format_prompt fun(params: cody.PromptParams): string Generate the request body.

---@enum (key) cody.ModelName
---@type table<string, cody.ModelConfig>
M.models = {
	["fireworks::v1::starcoder"] = require "cody.models.starcoder",
	["fireworks::v1::deepseek-coder-v2-lite-base"] = require "cody.models.deepseek",
}

return M
