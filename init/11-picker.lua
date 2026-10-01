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
		ui_select = false,
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

vim.keymap.set("n", "<leader><leader>b", function()
	Snacks.picker.buffers {
		sort_lastused = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	Snacks.picker.smart {
		multi = {
			{
				source = "buffers",
				filter = { cwd = true },
			},
			{
				source = "recent",
				filter = { cwd = true },
			},
			"files",
		},
		cwd = vim.fs.root(0, {".git", ".project"}),
	}
end)

vim.keymap.set("n", "<leader><leader>F", function()
	Snacks.picker.files {
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	Snacks.picker.grep {
		cwd = vim.fs.root(0, {".git", ".project"}),
	}
end)

vim.keymap.set("n", "<leader><leader>G", function()
	Snacks.picker.grep {
	}
end)
