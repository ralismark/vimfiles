local M = {} -- TODO document

local packs_cache = nil
function M.packs()
	if packs_cache ~= nil then
		return packs_cache
	end

	local packs = {}

	local function handle_pack(path, is_opt)
		local name = vim.fn.fnamemodify(path, ":t")
		if packs[name] ~= nil then
			error("duplicate package " .. name)
		end
		if not is_opt then
			packs[name] = {
				load = function() end,
				path = path,
			}
		else
			packs[name] = {
				load = function() vim.cmd("packadd! " .. name) end,
				path = path,
			}
		end
	end

	for _, path in pairs(vim.fn.globpath(vim.o.packpath, "pack/*/start/*", false, true)) do
		handle_pack(path, false)
	end
	for _, path in pairs(vim.fn.globpath(vim.o.packpath, "pack/*/opt/*", false, true)) do
		handle_pack(path, true)
	end

	packs_cache = packs
	return packs_cache
end

function M.setup(config)
	-- convention: config keys are flake names
	for name, fn in pairs(config) do
		local shortname = name:gsub(".*/", ""):gsub(".*:", "")
		local pack = M.packs()[shortname]

		local extern_prefix = "extern:"
		if name:sub(0, #extern_prefix) == extern_prefix then
			-- external
		else
			-- managed in flake
			local flake = require "vimrc.flake".inputs()[name]
			if flake == nil then
				pack = nil
			end
		end

		if pack == nil then
			print("no package with name " .. vim.inspect(shortname))
		else
			pack.load()
			fn()
		end
	end
end

return M
