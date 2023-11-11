local hemline = require "vimrc.hemline"

-- TODO more comprehensive special-casing of "" segments

function _G.powerline_right(l, r, props)
	local rpad = r.content ~= "" and " " or ""
	if r.hl.bg == l.hl.bg then
		return {
			{ content = " " .. require"unicode".powerline_light_right .. rpad, hl = { fg = props.hl.fg, bg = l.hl.bg } },
		}
	else
		return {
			{ content = " ", hl = { bg = l.hl.bg } },
			{ content = require"unicode".powerline_heavy_right .. rpad, hl = { bg = r.hl.bg, fg = l.hl.bg } },
		}
	end
end

function _G.powerline_left(l, r, props)
	local lpad = l.content ~= "" and " " or ""
	if r.hl.bg == l.hl.bg then
		return {
			{ content = lpad .. require"unicode".powerline_light_left .. " ", hl = { fg = props.hl.fg, bg = l.hl.bg } },
		}
	else
		return {
			{ content = lpad .. require"unicode".powerline_heavy_left, hl = { bg = l.hl.bg, fg = r.hl.bg } },
			{ content = " ", hl = { bg = r.hl.bg } },
		}
	end
end

function _G.lcap(ch)
	return {
		"",
		ch,
		sep = function(_, r, props)
			if r.hl.bg == props.hl.bg then return {} end
			return {
				{ content = require"unicode".powerline_heavy_left, hl = { fg = r.hl.bg, bg = props.hl.bg } },
				{ content = " ", hl = r.hl },
			}
		end,
	}
end

function _G.rcap(ch)
	return {
		ch,
		"",
			sep = function(l, _, props)
				if l.hl.bg == props.hl.bg then return {} end
				return {
					{ content = " ", hl = l.hl },
					{ content = require"unicode".powerline_heavy_right, hl = { fg = l.hl.bg, bg = props.hl.bg } },
				}
			end,
	}
end

function _G.lrcap(x)
	return lcap(rcap(x))
end

-------------------------------------------------------------------------------

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
		if vim.bo.buftype == "" then
			if vim.api.nvim_buf_get_name(0) == "" then
				return { { "(untitled)", hl={fg="grey", italic=true} }, vim.bo.modified and "*" }
			end
			return {
				{ shortname():gsub("%%", "%%%%"), hl={italic=not vim.fn.filereadable(vim.api.nvim_buf_get_name(0))} },
				vim.bo.modified and "*",
			}
		elseif vim.bo.buftype == "terminal" then
			return { ">_", hl={bg="magenta"} }
		elseif vim.bo.buftype == "quickfix" then
			return { vim.fn.win_gettype(), hl={bg="green"} }
		elseif vim.bo.buftype == "help" then
			return { vim.fn.expand("%:t"), hl={bg="darkyellow"} }
		else
			return vim.api.nvim_buf_get_name(0)
		end
	end,
} end

local eol = function()
	if vim.o.ff == "unix" then
		if vim.fn.has("unix") > 0 or vim.fn.has("linux") > 0 or vim.fn.has("bsd") > 0 then
			return nil
		else
			return "\\n"
		end
	end
	if vim.o.ff == "dos" then
		if vim.fn.has("win32") > 0 then
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
end

local function mainbar(is_active)
	local theme = {
		a = is_active and { fg = "black", bg = "white" } or { fg = "black", bg = "darkgrey" },
		b = is_active and { fg = "white", bg = "none" } or { fg = "grey", bg = "none" },
	}

	return {
		lrcap {
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
			sep = powerline_right,
		},

		function()
			local ch = is_active and require"unicode".heavy_horizontal or require"unicode".light_horizontal
			local hr = " %<" .. ch:rep(vim.api.nvim_win_get_width(vim.g.statusline_winid)) .. "> "
			return {
				hr,
				hl = { fg = is_active and (vim.api.nvim_tabpage_get_number(0)%6)+9 or "darkgrey" },
			}
		end,

		lrcap {
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
					local clients = vim.tbl_values(vim.tbl_map(function(x) return x.name end, vim.lsp.buf_get_clients()))
					if #clients == 0 then
						return nil
					end
					return { {"🗲 ", hl={fg="darkyellow"}}, table.concat(vim.fn.uniq(vim.fn.sort(clients)), " ")}
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

			sep = powerline_left,
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
