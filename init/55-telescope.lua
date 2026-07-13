local telescope = require "telescope"
local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local conf = require "telescope.config".values

local async = require "plenary.async"

telescope.setup {
	extensions = {
		fzf = {
			fuzzy = false,
		}
	},
	defaults = {
		scroll_strategy = "limit",

		path_display = {
			filename_first = {},
		},

		mappings = {
			i = {
				["<esc>"] = actions.close,
			}
		},
	},
}
telescope.load_extension("fzf")

local function search_root()
	local search = vim.fs.find({".git", ".project"}, { upward = true })
	if #search > 0 then
		return vim.fs.dirname(search[1])
	end
	return vim.uv.cwd()
end

local function file_jumper_finder(opts)
	-- if prompt is an existing file, if relative to (actual) cwd or one of its
	-- parents within opts.cwd, also show it
	local cwd = vim.uv.cwd()
	local parents = {cwd}
	for dir in vim.fs.parents(cwd) do
		table.insert(parents, dir)
	end

	return setmetatable({
		entry_maker = opts.entry_maker,
		close = function() end,
	}, {
		__call = function(self, prompt, process_result, process_complete)
			for _, dir in ipairs(parents) do
				local path = vim.fs.joinpath(dir, prompt)
				if vim.uv.fs_stat(path) then
					local rel = vim.fs.relpath(opts.cwd, path)
					process_result(self.entry_maker(rel))
				end
			end
			process_complete()
		end,
	})
end

local function recent_files_finder(opts)
	local results = {}

	local submit = function(path)
		if vim.fn.filereadable(path) == 1 then
			local rel = vim.fs.relpath(opts.cwd, path)
			if rel and not vim.list_contains(results, rel) then
				results[#results + 1] = rel
			end
		end
	end

	-- gather open files
	for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n")) do
		local match = tonumber(string.match(buffer, "%s*(%d+)"))
		local open_by_lsp = string.match(buffer, "line 0$")
		if match and not open_by_lsp then
			submit(vim.api.nvim_buf_get_name(match))
		end
	end

	-- gather recent files
	for _, file in ipairs(vim.v.oldfiles) do
		submit(file)
	end

	return require "telescope.finders".new_table {
		results = results,
		entry_maker = opts.entry_maker,
	}
end

local function merge_finders(finders)
	return setmetatable({
		close = function()
			for _, finder in ipairs(finders) do
				if finder.close then
					finder:close()
				end
			end
		end,
	}, {
		__call = function(self, prompt, process_result, process_complete)
			local waiting = #finders
			for i, finder in ipairs(finders) do
				finder(
					prompt,
					function(entity)
						entity._finder_idx = i
						process_result(entity)
					end,
					function()
						waiting = waiting - 1
						if waiting == 0 then
							process_complete()
						end
					end
				)
			end
		end,
	})
end

---@param sorter Sorter
local function merge_sorter(sorter)
	local scoring_function_super = sorter.scoring_function
	sorter.scoring_function = function(self, prompt, ordinal, entity, cb_add, cb_filter)
		local score = scoring_function_super(self, prompt, ordinal, entity, cb_add, cb_filter)
		if score == -1 then
			return -1
		end

		return 2 * entity._finder_idx + score
	end
	return sorter
end

local function combo_files(opts)
	opts.cwd = opts.cwd or vim.uv.cwd()
	opts.prompt_title = opts.results_title or "Files"
	opts.entry_maker = opts.entry_maker or require "telescope.make_entry".gen_from_file(opts)

	pickers.new(opts, {
		finder = merge_finders {
			recent_files_finder(opts),
			file_jumper_finder(opts),
			require("telescope.finders").new_oneshot_job({
				"rg", "--files", "--color=never",
			}, opts),
		},
		previewer = conf.file_previewer(opts),
		sorter = merge_sorter(conf.generic_sorter(opts)),
	}):find()
end

vim.keymap.set("n", "<leader><leader>b", function()
	require "telescope.builtin".buffers {
		sort_mru = true,
	}
end)

vim.keymap.set("n", "<space><space>r", function()
	local opts = {
		cwd = search_root()
	}
	opts.cwd = opts.cwd or vim.uv.cwd()
	opts.prompt_title = opts.results_title or "Recent & Nearby Files"
	opts.entry_maker = opts.entry_maker or require "telescope.make_entry".gen_from_file(opts)

	pickers.new(opts, {
		finder = merge_finders {
			recent_files_finder(opts),
			file_jumper_finder(opts),
		},
		previewer = conf.file_previewer(opts),
		sorter = merge_sorter(conf.generic_sorter(opts)),
	}):find()
end)

vim.keymap.set("n", "<space><space>f", function()
	combo_files {
		cwd = search_root()
	}
end)

vim.keymap.set("n", "<space><space>F", function()
	combo_files {
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
		cwd = search_root()
	}
end)

vim.keymap.set("n", "<leader><leader>G", function()
	require "telescope.builtin".live_grep {
	}
end)

vim.keymap.set("n", "<leader><leader>q", function()
	require "telescope.builtin".quickfix {
	}
end)
