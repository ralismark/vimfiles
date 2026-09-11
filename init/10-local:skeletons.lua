local augroup = require"vimrc".augroup()

vim.api.nvim_create_autocmd("BufNewFile", {
	group = augroup,
	pattern = "*",
	desc = "vimrc.skeletons",
	callback = (require "vimrc.skeletons").expand,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	group = augroup,
	pattern = "default.nix",
	desc = "flake-compat default.nix",
	callback = function()
		if vim.fn.expand("<afile>:t")~= "default.nix" then
			return
		end

		local flake = vim.fs.joinpath(vim.fn.expand("<afile>:p:h"), "flake.nix")
		if not vim.uv.fs_stat(flake) then
			return
		end

		-- time to write out template
		vim.api.nvim_buf_set_lines(0, 0, -1, true, {
			"(import (",
			"  let",
			"    lock = builtins.fromJSON (builtins.readFile ./flake.lock);",
			"    nodeName = lock.nodes.root.inputs.flake-compat;",
			"  in",
			"  fetchTarball {",
			"    url =",
			"      lock.nodes.${nodeName}.locked.url",
			"        or \"https://github.com/NixOS/flake-compat/archive/${lock.nodes.${nodeName}.locked.rev}.tar.gz\";",
			"    sha256 = lock.nodes.${nodeName}.locked.narHash;",
			"  }",
			") { src = ./.; }).defaultNix",
		})
	end,
})
