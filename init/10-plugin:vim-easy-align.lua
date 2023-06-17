-- Start interactive EasyAlign in visual mode (e.g. vipga)
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", {
	remap = true,
})

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", {
	remap = true,
})

vim.g.easy_align_delimiters = {
	t = {
		pattern = "\\t",
		left_margin = 0,
		right_margin = 0,
		stick_to_left = 1,
	},
}
