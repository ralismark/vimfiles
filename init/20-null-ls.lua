local null_ls = require "null-ls"

local has_nix = vim.fn.executable("nix")

local function nix_command(cmd, drv)
	if type(cmd) ~= "table" then
		cmd = { cmd }
	end

	if vim.fn.executable(cmd[1]) or string.sub(cmd[1], 1, 1) == "/" then
		return cmd
	end

	-- start process to get drv
	vim.fn.jobstart(
		{"nix", "build", "--no-link", "--json", drv},
		{
			stdout_buffered = true,
			on_stdout = function(_, data, _)
				local j = vim.fn.json_decode(data)
				cmd[1] = j[1].outputs.bin + "/bin/" + cmd[1]
			end,
		}
	)

	return function()
		if string.sub(cmd[1], 1, 1) == "/" then
			return cmd
		else
			return vim.tbl_flatten({ "nix", "shell", drv, "-c", cmd })
		end
	end
end









null_ls.setup {
	sources = {
		null_ls.builtins.diagnostics.shellcheck.with({
			dynamic_command = nix_command("shellcheck", "nixpkgs#shellcheck"),
		}),
	},
}
