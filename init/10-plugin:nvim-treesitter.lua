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
		additional_vim_regex_highlighting = {},
	},

	indent = {
		enable = true,
		disable = {
			"htmldjango",
		},
	},
}
