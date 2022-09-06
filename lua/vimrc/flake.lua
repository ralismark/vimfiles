local M = {}
M.Input = {}

function M.Input:url()
	if self.original == nil then
		error("No original")
	end

	local function to_query(q)
		local s = ""
		for key, val in pairs(q) do
			if s == nil then
				s = s .. "?"
			else
				s = s .. "&"
			end
			s = s .. key .. "=" .. val
		end
		return s
	end

	if self.original.type == "github" then
		local s = "github:" .. self.original.owner .. "/" .. self.original.repo
		s = s .. to_query {
			dir = self.original.dir,
			ref = self.original.ref,
		}
		return s
	end

	error("Unknown type " .. self.original.type)
end

local mt = {
	__index = M.Input,
}

local lock_cache = nil
function M.lock()
	if lock_cache ~= nil then
		return lock_cache
	end

	local flake = vim.json.decode(vim.fn.readfile(vim.g.flake_lock, "B"))
	if flake.version ~= 7 then
		error("Unknown flake version")
	end

	-- resolve all input refs
	for _, pkg in pairs(flake.nodes) do
		if pkg.inputs ~= nil then
			for key, ref in pairs(pkg.inputs) do
				pkg.inputs[key] = flake.nodes[ref]
			end
		end
		setmetatable(pkg, mt)
	end

	-- resolve root
	flake.root = flake.nodes[flake.root]

	lock_cache = flake
	return lock_cache
end

function M.inputs()
	return M.lock().root.inputs
end

return M
