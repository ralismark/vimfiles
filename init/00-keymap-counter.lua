local augroup = require"vimrc".augroup()

local LOGFILE = vim.fn.stdpath("log") .. "/keyfreq.json"

---@type table<string, integer>
local counters = {}

local function flush()
	-- load file
	local savedcount = {}
	local file = io.open(LOGFILE, "r")
	if file then
		local content = file:read("*a")
		file:close()
		savedcount = vim.json.decode(content)
	end

	-- update count
	for key, count in pairs(counters) do
		savedcount[key] = (savedcount[key] or 0) + count
	end

	-- save file
	file = io.open(LOGFILE, "w")
	if file then
		file:write(vim.json.encode(savedcount))
		file:close()
		counters = {}
	end
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "VimLeavePre" }, {
	callback = flush,
	desc = "Flush keymap counter",
})

-------------------------------------------------------------------------------

local old_keymap_set = vim.keymap.set

---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
	opts = opts or {}
	local caller = debug.getinfo(2, "S")
	opts.desc = (opts.desc or "") .. "\nrhs=" .. vim.inspect(rhs) .. "\n(set from " .. caller.source .. ")"
	if type(rhs) == "string" then
		opts.expr = true
		opts.replace_keycodes = true
	end

	old_keymap_set(mode, lhs, function()
		local key = vim.fn.mode() .. "," .. lhs
		counters[key] = (counters[key] or 0) + 1
		if type(rhs) == "function" then
			return rhs()
		else
			-- print("a", rhs)
			return rhs
		end
	end, opts)
end
