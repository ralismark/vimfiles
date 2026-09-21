local snacks = require "snacks"

snacks.setup {
	picker = {
		enter = true,
		layout = "telescope",
		win = {
			-- input window
			input = {
				keys = {
					-- to close the picker on ESC instead of going to normal mode,
					-- add the following keymap to your config
					["<Esc>"] = { "close", mode = { "n", "i" } },
				},
			},
		},
	},
}

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "none", nocombine = true })
		vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "fg", bg = "none", nocombine = true })
	end,
})

-------------------------------------------------------------------------------

local function search_root()
	local search = vim.fs.find({".git", ".project"}, { upward = true })
	if #search > 0 then
		return vim.fs.dirname(search[1])
	end
	return nil
end

vim.keymap.set("n", "<leader><leader>b", function()
	Snacks.picker.buffers {
		sort_lastused = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	Snacks.picker.smart {
		cwd = search_root()
	}
end)

vim.keymap.set("n", "<leader><leader>F", function()
	Snacks.picker.smart {
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	Snacks.picker.grep {
		cwd = search_root()
	}
end)

vim.keymap.set("n", "<leader><leader>G", function()
	Snacks.picker.grep {
	}
end)
