local detect = require "vim.filetype.detect"

-- always want .tf to mean terraform
---@diagnostic disable-next-line: duplicate-set-field
detect.tf = function (_, _)
	return "terraform"
end

vim.filetype.add {
	filename = {
		[".envrc"] = "sh"
	},
}
