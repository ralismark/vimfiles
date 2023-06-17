local function lazy(e)
	return function()
		local val = vim.fn.eval(e)
		if val == "" then
			return nil
		end
		return val
	end
end

require "vimrc.statusline".setup {
	components = {
		filename = function() return vim.api.nvim_buf_get_name(0) end,
		position = function() return vim.fn.line(".") end,
		ll_buftype = lazy("&bt"),
		ll_filename = lazy("ll#filename()"),
		ll_rostate = lazy("ll#rostate()"),
		ll_wordcount = lazy("ll#wordcount()"),
		ll_lsp = {
			-- visible = function() return vim.fn.winwidth(0) > 40 end,
			content = function()
				local clients = vim.tbl_values(vim.tbl_map(function(x) return x.name end, vim.lsp.buf_get_clients()))
				if #clients == 0 then
					return nil
				end
				return "lsp:" .. table.concat(vim.fn.uniq(vim.fn.sort(clients)), " ")
			end,
		},
		eol = function()
			if vim.o.ff == "unix" then
				if vim.fn.has("unix") > 0 or vim.fn.has("linux") > 0 or vim.fn.has("wsl") > 0 or vim.fn.has("bsd") > 0 then
					return nil
				else
					return "\\n"
				end
			end
			if vim.o.ff == "dos" then
				if vim.fn.has("win22") > 0 or vim.fn.has("win64") > 0 then
					return nil
				else
					return "\\r\\n"
				end
			end
			if vim.o.ff == "mac" then
				if vim.fn.has("mac") > 0 then
					return nil
				else
					return "\\r"
				end
			end
		end,
		ll_filetype = lazy("ll#filetype()"),
		ll_blur_ft = lazy("ll#nonfile() ? '' : &ft"),
		ll_location = lazy("ll#location()"),
		n_errors = {
			content = function()
				local n_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				if n_errors == 0 then
					return nil
				end
				return "✕ " .. n_errors
			end,
			color = "Error",
		},
	},
	active = {
		a = { },
		b = { "ll_filename", },
		c = { "ll_buftype", "ll_rostate", "ll_wordcount" },
		x = { "ll_lsp", "eol", "ll_filetype" },
		y = { "ll_location" },
		z = { "n_errors" },
	},
	inactive = {
		a = { },
		b = { "ll_filename", },
		c = { "ll_rostate", "ll_wordcount" },
		x = { "ll_lsp", "eol", "ll_blur_ft" },
		y = { "ll_location" },
		z = { "n_errors" },
	},
}
