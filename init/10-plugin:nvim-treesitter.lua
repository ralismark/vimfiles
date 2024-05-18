require "nvim-treesitter.configs".setup {
	auto_install = false, -- managed by nix

	highlight = {
		enable = true,
		disable = {"nix", "help", "markdown", "pandoc"},
		custom_captures = {
		},
		additional_vim_regex_highlighting = {},
	},

	-- TODO

	indent = {
		enable = false,
	},
}
