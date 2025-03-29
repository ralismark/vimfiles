return {

	-- For Claude, a token approximately represents 3.5 English characters.
	-- see: https://docs.anthropic.com/claude/docs/glossary#tokens
	chars_per_token = 3.5,

	-- Settings for autocomplete
	autocomplete = {
		enable = true,

		-- cody.ModelName, or nil to fetch the default complete model from
		-- sourcegraph
		model = "fireworks::v1::deepseek-coder-v2-lite-base",

		-- The proportion of the token limit that should used for context.
		context_proportion = 0.9,
	},

}
