local M = {}

local flake_data = nil
function M.flake_data()
	if flake_data == nil then
		-- load flake lock
		local data = {}
		local flake = vim.json.decode(vim.fn.readfile(vim.g.flake_lock, "B"))
		if flake.version ~= 7 then
			error("Unknown flake version")
		end
		local inputs = flake.nodes[flake.root].inputs
		for name, dep in pairs(inputs) do
			if name:find("^plugin") ~= nil then
				local spec = flake.nodes[dep].locked
				local fullname = spec.owner .. "/" .. spec.repo
				data[fullname] = {
					shortname = name:sub(8)
				}
			end
		end

		flake_data = data
	end
	return flake_data

end

function M.setup(config)
	local packs = {}

	local function handle_pack(path, is_opt)
		local name = vim.fn.fnamemodify(path, ":t")
		if packs[name] ~= nil then
			error("duplicate package " .. name)
		end
		if not is_opt then
			packs[name] = function() end
		else
			packs[name] = function() vim.cmd("packadd! " .. name) end
		end
	end

	for _, path in pairs(vim.fn.globpath(vim.o.packpath, "pack/*/start/*", false, true)) do
		handle_pack(path, false)
	end
	for _, path in pairs(vim.fn.globpath(vim.o.packpath, "pack/*/opt/*", false, true)) do
		handle_pack(path, true)
	end

	for name, value in pairs(config) do
		local shortname = name:gsub(".*/", "")
		local flake = M.flake_data()[name]
		if flake == nil or packs[shortname] == nil then
			print("no package with name " .. vim.inspect(name))
		else
			local pack = packs[shortname]
			pack()
			value()
		end
	end
end

return M
