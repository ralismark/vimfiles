local telescope = require "telescope"
local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local conf = require "telescope.config".values

local async = require "plenary.async"

telescope.setup {
	extensions = {
		fzf = {
			fuzzy = false,
		},
	},
	defaults = {
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
	return vim.uv.cwd()
end

local function file_multi_picker(opts)
	local found_files = {} -- easy lookup of found files
	local queue = require "plenary.async.structs".Deque.new()

	local function entry_display(v)
		return v._display, v._hi
	end
	local entry_maker = opts.entry_maker or function(v)
		local path, hi = require "telescope.utils".transform_path(opts, v.rel)

		return {
			filename = v.path,
			ordinal = v.rel,
			display = entry_display,
			_display = path,
			_hi = hi,

			value = v,
		}
	end
	local submit = function(path, source)
		if found_files[path] then
			return
		end
		found_files[path] = true

		-- only submit ones under cwd
		local rel = vim.fs.relpath(opts.cwd, path)
		if not rel then
			return
		end

		queue:pushleft({
			path = path,
			rel = rel,
			source = source,
		})
	end

	-- gather open files
	for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n")) do
		local match = tonumber(string.match(buffer, "%s*(%d+)"))
		local open_by_lsp = string.match(buffer, "line 0$")
		if match and not open_by_lsp then
			local file = vim.api.nvim_buf_get_name(match)
			if vim.fn.filereadable(file) == 1 then
				submit(file, "open")
			end
		end
	end

	-- gather recent files
	for _, file in ipairs(vim.v.oldfiles) do
		if vim.fn.filereadable(file) == 1 then
			submit(file, "recent")
		end
	end

	-- gather all files
	require "plenary.scandir".scan_dir_async(opts.cwd, {
		respect_gitignore = true,
		on_insert = function(file)
			submit(file, "scan")
		end,
	})

	-- extra: if prompt is an existant file, if relative to (actual) cwd or one
	-- of its parents within opts.cwd, also show it
	local parents = {}
	for dir in vim.fs.parents(vim.uv.cwd()) do
		if vim.fs.relpath(opts.cwd, dir) then
			table.insert(parents, dir)
		end
	end

	return setmetatable({
		results = {},
		close = function() end,
		entry_maker = entry_maker,
	}, {
		__call = function(self, prompt, process_result, process_complete)
			-- check if prompt exists
			for _, dir in ipairs(parents) do
				local path = vim.fs.joinpath(dir, prompt)
				if vim.fn.filereadable(path) == 1 then
					local rel = vim.fs.relpath(opts.cwd, path)
					if rel then
						process_result(entry_maker {
							path = path,
							rel = rel,
							source = "rel",
						})
					end
				end
			end

			for _, v in ipairs(self.results) do
				process_result(v)
			end

			local count = 0

			while not queue:is_empty() do
				local entry = entry_maker(queue:popright())
				table.insert(self.results, entry)
				process_result(entry)

				count = count + 1
				if count % 100 == 0 then
					async.util.scheduler()
				end
			end
			process_complete()
		end,
	})
end

vim.keymap.set("n", "<space><space>f", function()
	local root = search_root()

	local opts = {
		cwd = root,
	}

	pickers.new(opts, {
		finder = file_multi_picker(opts),
		previewer = conf.file_previewer(opts),
		sorter = conf.file_sorter(opts),
	}):find()
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
	}
end)

vim.keymap.set("n", "<leader><leader>q", function()
	require "telescope.builtin".quickfix {
	}
end)
