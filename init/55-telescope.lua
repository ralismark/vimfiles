local telescope = require "telescope"

telescope.setup {
	extensions = {
		fzf = {
			fuzzy = false,
		}
	}
}
telescope.load_extension("fzf")

vim.keymap.set("n", "<leader><leader>b", function()
	require "telescope.builtin".buffers {
		sort_mru = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	require "telescope.builtin".find_files {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
	}
end)
