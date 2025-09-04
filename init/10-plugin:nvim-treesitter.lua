require "nvim-treesitter.configs".setup {
	auto_install = false, -- managed by nix

	highlight = {
		enable = true,
		disable = {
			"nix",
			"help",
			"markdown",
			"pandoc",
			"django",
			"htmldjango",
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
