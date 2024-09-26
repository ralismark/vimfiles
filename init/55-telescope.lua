-- add rg to path if nix available
if vim.fn.executable("nix") == 1 and vim.fn.executable("rg") == 0 then
	vim.system(
		{ "nix", "build", "-f", "<nixpkgs>", "ripgrep", "--no-link", "--print-out-paths"},
		{ },
		function(obj)
			vim.schedule(function()
				if obj.code ~= 0 then
					vim.api.nvim_err_writeln("nix build exited with status " .. obj.code .. "\n" .. obj.stderr)
				else
					vim.env.PATH = obj.stdout:gsub("\n", "/bin:") .. vim.env.PATH
				end
			end)
		end
	)
end

vim.keymap.set("n", "<leader><leader>b", function()
	require "telescope.builtin".buffers {
		sort_mru = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	require "telescope.builtin".find_files {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
	}
end)
