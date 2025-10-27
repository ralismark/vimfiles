vim.fn["textobj#user#plugin"]("entire", {
	entire = {
		select = "-",
		pattern = "\\%^\\_.*\\%$",
		["region-type"] = "V",
	},
})
