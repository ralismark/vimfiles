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

local function search_root()
	local search = vim.fs.find({".git", ".project"}, { upward = true })
	if #search > 0 then
		return vim.fs.dirname(search[1])
	end
	return vim.fn.getcwd()
end

vim.keymap.set("n", "<leader><leader>f", function()
	require "telescope.builtin".find_files {
		cwd = search_root(),
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
		cwd = search_root(),
	}
end)
