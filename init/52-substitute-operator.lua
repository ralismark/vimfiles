vim.keymap.set("n", "-", function()
	_G.operatorfunc = function(motion)
		local replacement = vim.fn.getreg(vim.v.register, 1, true) --[=[@as string[]]=]
		local left = vim.api.nvim_buf_get_mark(0, "[")
		local right = vim.api.nvim_buf_get_mark(0, "]")

		-- correctly order
		if left[1] > right[1] or (left[1] == right[1] and left[2] > right[2]) then
			left, right = right, left
		end

		-- print(motion, vim.inspect(left), vim.inspect(right), vim.inspect(replacement))

		if motion == "line" then
			vim.api.nvim_buf_set_lines(0, left[1] - 1, right[1], false, replacement)
		elseif motion == "char" then
			-- handle "end-of-line"
			if right[2] == 0 then
				right = { right[1], -1 }
			end

			vim.api.nvim_buf_set_text(0, left[1] - 1, left[2], right[1] - 1, right[2] + 1, replacement)
		elseif motion == "block" then
			-- TODO block motion
		end
	end
	vim.o.operatorfunc = "v:lua.operatorfunc"
	return "g@"
end, {
	expr = true,
})

-- TODO mapping for ss
-- TODO visual mode
