local hemline = require "vimrc.hemline"

local function relpath()
	local pathparts = vim.fn.split(vim.fn.expand("%:p"), "/")
	local cwdparts = vim.fn.split(vim.fn.getcwd(), "/")

	local ncommon = 0
	while #pathparts > ncommon + 1 and #cwdparts >= ncommon and pathparts[ncommon+1] == cwdparts[ncommon+1] do
		ncommon = ncommon + 1
	end

	return ("../"):rep(#cwdparts - ncommon) .. table.concat(table.slice(pathparts, ncommon + 1), "/")
end

local function shortname()
	local apath = vim.fn.expand("%:~:.")
	local rpath = relpath()
	return #apath < #rpath and apath or rpath
end

local filename = function(is_active) return {
	function()
		if vim.bo.buftype == "" or vim.bo.buftype == "nowrite" then
			local untitled = vim.api.nvim_buf_get_name(0) == ""
			local displayname = untitled and "(untitled)" or shortname():gsub("%%", "%%%%")
			local exists = not untitled and vim.uv.fs_stat(vim.api.nvim_buf_get_name(0)) ~= nil
			return {
				{ displayname, hl={fg=not exists and "grey" or nil} },
				vim.bo.modified and "*",
				hl={italic=vim.bo.modified},
			}
		elseif vim.bo.buftype == "terminal" then
			return { ">_", hl={bg="magenta"} }
		elseif vim.bo.buftype == "quickfix" then
			return { vim.fn.win_gettype(), hl={bg="green"} }
		elseif vim.bo.buftype == "help" then
			return { vim.fs.basename(vim.api.nvim_buf_get_name(0)), hl={bg="darkyellow"} }
		else
			return vim.api.nvim_buf_get_name(0)
		end
	end,
} end

local sysname = vim.uv.os_uname().sysname

local eol = function()
	if vim.o.ff == "unix" then
		return sysname == "Windows_NT" and "\\n" or nil
	elseif vim.o.ff == "dos" then
		return sysname ~= "Windows_NT" and "\\r\\n" or nil
	elseif vim.o.ff == "mac" then
		return sysname ~= "Darwin" and "\\r" or nil
	end
end

local function mainbar(is_active)
	local theme = {
		a = is_active and { fg = "black", bg = "white" } or { fg = "black", bg = "darkgrey" },
		b = is_active and { fg = "white", bg = "none" } or { fg = "grey", bg = "none" },
	}

	return {
		hemline.powerline.lrcap {
			{
				filename(is_active),

				hl = theme.a,
				sep = "inherit",
			},
			function() return vim.bo.buftype == "" and {
				{ function() return vim.bo.readonly and "ro" end, hl={fg="yellow"} },
				eol,
				function() return vim.bo.filetype ~= "" and vim.bo.filetype or { "no ft", hl={italic=true} } end,

				hl = theme.b,
				sep = "inherit",
			} end,
			sep = hemline.powerline.sep_right,
		},

		function()
			local ch = hemline.powerline[
				(is_active and "heavy" or "light")
				.. (vim.bo.modified and "_dashed" or "")
				.. "_horizontal"
			]
			local hr = " %<" .. ch:rep(vim.api.nvim_win_get_width(vim.g.statusline_winid)) .. "> "
			return {
				hr,
				hl = { fg = is_active and (vim.api.nvim_tabpage_get_number(0)%6)+9 or "darkgrey" },
			}
		end,

		hemline.powerline.lrcap {
			{
				-- diagnostics
				function()
					local errs = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

					return {
						warns > 0 and { "▲" .. warns, hl={fg="yellow"} },
						errs > 0 and { "×" .. errs, hl={fg="red",bold=true} },
						sep = function(_, _, props) return { { content = " ", hl = props.hl } } end,
					}
				end,

				-- lsp clients
				function()
					local clients = vim.tbl_values(vim.tbl_map(function(x) return x.name end, vim.lsp.get_clients{bufnr=0}))
					if #clients == 0 then
						return nil
					end
					table.sort(clients)
					return { {"🗲 ", hl={fg="darkyellow"}}, table.concat(vim.list.unique(clients), " ")}
				end,

				hl = theme.b,
				sep = "inherit",
			},
			{
				function()
					if not vim.wo.spell then return end
					local wc = vim.fn.wordcount()
					return {
						("%d/%d words"):format(
							wc.cursor_words or wc.visual_words or 1,
							wc.words
						),
						hl={bg="darkgrey", fg=is_active and "white" or "black"},
					}
				end,
				"%P %3l:%-2c",

				hl = theme.a,
				sep = "inherit",
			},

			sep = hemline.powerline.sep_left,
		},
	}
end

rc.statusline = hemline.make_statusline {
	bars = {
		active = mainbar(true),
		inactive = mainbar(false),
	},
}

-------------------------------------------------------------------------------

vim.g.qf_disable_statusline = true
vim.go.statusline = [[%!v:lua.rc.statusline()]]
