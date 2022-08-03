local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

return function(opts)
	opts = opts or {}
	opts.entry_maker = opts.entry_maker or require "telescope.make_entry".gen_from_file(opts)

	local finder = finders.new_oneshot_job(
		vim.tbl_flatten {
			"tunnel-run",
			"find",
			".",
			opts.follow and {
				"-L",
			} or {},
			opts.hidden and {} or {
				"-name", ".?*", "-prune", "-o",
			},
			"-type", "f",
			"-print",
		},
		opts
	)

	pickers.new(opts, {
		prompt_title = "Find Files",
		finder = finder,
		previewer = conf.file_previewer(opts),
		sorter = conf.generic_sorter(opts),
	}):find()
end
