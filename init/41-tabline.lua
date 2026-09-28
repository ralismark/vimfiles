local hemline = require "vimrc.hemline"

local tabline = {
	hl={bg=234,fg="white"},

	{
		"%=",
		sep = hemline.powerline.sep_right,
	},

	function()
		local o = {}
		table.insert(o, "")
		for i, handle in ipairs(vim.api.nvim_list_tabpages()) do
			local bufs = vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_tabpage_list_wins(handle))
			local any_modified = vim.tbl_contains(
				vim.tbl_map(function(b) return vim.bo[b].modified end, bufs),
				true
			)
			-- local win = vim.api.nvim_tabpage_get_win(handle)
			-- local buf = vim.api.nvim_win_get_buf(win)
			-- local bufname = vim.fn.expand("#" .. buf .. ":t")

			local active = handle == vim.api.nvim_get_current_tabpage()

			table.insert(o, {
				"%" .. i .. "T",
				("  %d%s "):format(i, any_modified and "*" or " "),
				"%0T",
				hl=active and {fg="black",bg=(i%6)+9} or {fg=(i%6)+9,bg=237},
			})
		end
		table.insert(o, "")

		function o.sep(l, r, props)
			local s = {}
			if l.content ~= "" then
				table.insert(s, { content = " ", hl={bg=l.hl.bg} })
				table.insert(s, { content = hemline.powerline.heavy_right, hl={fg=l.hl.bg, bg=props.hl.bg} })
			end
			table.insert(s, { content = " ", hl = props.hl })
			if r.content ~= "" then
				table.insert(s, { content = hemline.powerline.heavy_left, hl={fg=r.hl.bg, bg=props.hl.bg} })
				table.insert(s, { content = " ", hl={bg=r.hl.bg} })
			end
			return s
		end
		return o
	end,

	{
		"%=",
		function()
			local errs = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
			local warns = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })

			return {
				warns > 0 and { "▲" .. warns .. " ", hl={fg="yellow"} },
				errs > 0 and { "×" .. errs .. " ", hl={fg="red",bold=true} },
			}
		end,
		sep = hemline.powerline.sep_left,
	},
}

rc.tabline = function() return hemline.render(tabline) end
vim.go.showtabline = 2
vim.go.tabline = [[%!v:lua.rc.tabline()]]
