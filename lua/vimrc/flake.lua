local flake = vim.json.decode(vim.fn.readfile(vim.g.flake_lock, "B"))
if flake.version ~= 7 then
	error("Unknown flake version: " .. flake.version)
end

-- resolve all input refs
for _, pkg in pairs(flake.nodes) do
	if pkg.inputs ~= nil then
		for key, ref in pairs(pkg.inputs) do
			pkg.inputs[key] = flake.nodes[ref]
		end
	end
end

-- resolve root
flake.root = flake.nodes[flake.root]

local out = flake.root

-- metatable things
local mt = {}
setmetatable(out, mt)

-- TODO

return out
