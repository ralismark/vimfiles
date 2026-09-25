rc.host = {
	freestanding = not not (vim.g.freestanding and vim.g.freestanding ~= 0), -- convert to bool
}

-------------------------------------------------------------------------------

for _, python3path in pairs({
	vim.env.HOME .. "/.nix-profile/bin/python3",
}) do
	if vim.fn.executable(python3path) then
		vim.g.python3_host_prog = python3path
	end
end
