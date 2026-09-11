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
	return vim.uv.cwd()
end

vim.keymap.set("n", "<space><space>b", function()
	Snacks.picker.buffers {
		sort_lastused = true,
	}
end)

vim.keymap.set("n", "<space><space>f", function()
	Snacks.picker.files {
		cwd = search_root()
	}
end)

vim.keymap.set("n", "<space><space>F", function()
	Snacks.picker.files {
	}
end)

vim.keymap.set("n", "<space><space>g", function()
	Snacks.picker.grep {
		cwd = search_root()
	}
end)

vim.keymap.set("n", "<space><space>G", function()
	Snacks.picker.grep {
	}
end)
