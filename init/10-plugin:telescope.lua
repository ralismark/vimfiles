require "telescope".setup {
	defaults = {
		vimgrep_arguments = {
			"grep",
			"--extended-regexp",
			"--color=never",
			"--with-filename",
			"--line-number",
			"-b", -- grep doesn't support a `--column` option :(
			"--ignore-case",
			"--recursive",
			"--no-messages",
			"--exclude-dir=*cache*",
			"--exclude-dir=*.git",
			"--exclude=.*",
			--"--binary-files=without-match",
		},
		-- sorting_strategy = "ascending",
	},
}
