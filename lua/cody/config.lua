local M = {}

M.autocomplete_model = "fireworks::v1::deepseek-coder-v2-lite-base" --[[@as cody.ModelName]]

-- For Claude, a token approximately represents 3.5 English characters.
-- see: https://docs.anthropic.com/claude/docs/glossary#tokens
M.chars_per_token = 3.5

-- The proportion of the token limit that should used for context.
M.context_proportion = 0.9

return M
