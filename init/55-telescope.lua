vim.keymap.set("n", "<leader><leader>b", function()
	require "telescope.builtin".buffers {
		sort_mru = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	require "telescope.builtin".find_files {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
	}
	--[[
	local conf = require("telescope.config").values
	local opts = {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
		sorter = require "telescope.sorters".get_fuzzy_file(),
		entry_maker = require "telescope.make_entry".gen_from_file({})
	}

	local finder = require "telescope.finders".new_oneshot_job(
		{
			"find", ".",
			-- "-L", -- follow symlinks
			"-name", ".?*", "-prune", "-o", -- ignore hidden files
			"-type", "f",
			"-print",
		},
		opts
	)

	require "telescope.pickers".new(opts, {
		prompt_title = "Find Files",
		finder = finder,
		previewer = conf.file_previewer(opts),
		sorter = conf.generic_sorter(opts)
	}):find()
	]]
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
	}
end)
