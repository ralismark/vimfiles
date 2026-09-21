local augroup = require"vimrc".augroup()

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	desc = "treesitter",
	callback = function(ev)
		-- need to check that the parser exists
		local _, err = vim.treesitter.get_parser()
		if err ~= nil then
			return
		end

		-- highlight
		if not vim.tbl_contains({
			"nix",
			"help",
			"markdown",
			"pandoc",
			"django",
			"htmldjango",
		}, ev.match) then
			vim.treesitter.start()
		end

		-- indent
		if not vim.tbl_contains({
			"htmldjango",
		}, ev.match) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
