vim.keymap.set("n", "z=", function()
	local word = vim.fn.expand("<cword>")
	local suggests = vim.fn.spellsuggest(word, 8)

	vim.ui.select(suggests, {
		prompt = 'Change "' .. word .. '" to:',
		kind = "spell",
	}, function(item)
		if item then
			vim.cmd.normal { bang=true, "ciw" .. item }
		end
	end)
end, {
	desc = "Correct Spelling",
})
