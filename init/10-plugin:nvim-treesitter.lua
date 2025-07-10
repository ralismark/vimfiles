require "nvim-treesitter.configs".setup {
	auto_install = false, -- managed by nix

	highlight = {
		enable = true,
		disable = {
			"nix",
			"help",
			"markdown",
			"pandoc",
			"htmldjango",
		},
		custom_captures = {
			-- essentally, hi link @<key> = <value>
			["property.css"]      = "@attribute",

			["constant.builtin"]  = "Constant",
			["variable.css"]      = "Constant",

			["tag.delimiter"]     = "Delimiter",

			["function.builtin"]  = "NONE", -- nothing special

			["keyword.directive"] = "PreProc",
			["keyword.import"]    = "PreProc",

			["keyword.storage"]   = "StorageClass",
			["type.qualifier"]    = "StorageClass",

			["markup.link"]       = "Tag",

			["comment.todo"]      = "Todo",
		},
		additional_vim_regex_highlighting = {},
	},

	indent = {
		enable = true,
		disable = {
			"htmldjango",
		},
	},
}
