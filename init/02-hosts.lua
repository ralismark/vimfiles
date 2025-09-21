rc.host = {
	freestanding = not not (vim.g.freestanding and vim.g.freestanding ~= 0), -- convert to bool

	-- TODO potentially switch on this for per-system behaviour?
	whoami = string.format("%s@%s", vim.env.USER, vim.fn.hostname()),
}

-------------------------------------------------------------------------------

for _, python3path in pairs({
	vim.env.HOME .. "/.nix-profile/bin/python3",
}) do
	if vim.fn.executable(python3path) then
		vim.g.python3_host_prog = python3path
	end
end
