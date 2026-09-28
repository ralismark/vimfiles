local M = {}

---@class vimrc.hemline.Segment
---@field content string
---@field hl HighlightParams

---@alias vimrc.hemline.SegmentSpec
---| vimrc.hemline.ConcreteSegmentSpec
---| string
---| nil
---| fun(): vimrc.hemline.ConcreteSegmentSpec
---| fun(): string
---| fun(): nil

---@alias vimrc.hemlime.SepFn fun(l: vimrc.hemline.Segment, r: vimrc.hemline.Segment, props: table): vimrc.hemline.Segment[]

---@class vimrc.hemline.ConcreteSegmentSpec
---@field [integer] vimrc.hemline.SegmentSpec
---@field hl? HighlightParams
---@field sep? SepFn | "inherit"

---@class vimrc.hemline.ParentProps
---@field hl HighlightParams
---@field sep SepFn | nil

---@param spec vimrc.hemline.SegmentSpec
---@param parent vimrc.hemline.ParentProps
---@return vimrc.hemline.Segment[]
local function expand_spec(spec, parent)
	if type(spec) == "function" then
		spec = spec()
	end
	if type(spec) == "string" then
		return { { content = spec, hl = parent.hl } }
	end
	if not spec then
		return {}
	end
	local hl = vim.tbl_extend("force", parent.hl, spec.hl or {})

	local sep = spec.sep == "inherit" and parent.sep or spec.sep
	---@cast sep -string

	local segments = {}
	for _, child in ipairs(spec) do
		local csegs = expand_spec(child, {
			hl = hl,
			sep = sep,
		})
		if sep and #segments > 0 and #csegs > 0 then
			local mid = sep(segments[#segments], csegs[1], { hl = hl })
			table.append(segments, mid)
		end
		table.append(segments, csegs)
	end

	return segments
end

local highlighter = require "vimrc.highlighter" "hemline"

---@param segments Segment[]
---@return string
local function render_segments(segments)
	local s = ""
	for _, seg in ipairs(segments) do
		s = s .. ("%%#%s#%s"):format(
			highlighter.register(seg.hl),
			seg.content
		)
	end
	return s
end

---@alias Bar SegmentSpec

---Render a bar spec
---@param bar Bar
function M.render(bar)
	return render_segments(expand_spec(bar, {
		hl = { bg = "none" },
		sep = nil,
	}))
end

---@class StatuslineConfig
---@field bars { active: Bar, inactive: Bar, [string]: Bar }
---@field pick_bar? fun(active: boolean): string?

---@param config StatuslineConfig
---@return fun(): string
function M.make_statusline(config)
	local function pick_bar(active)
		return (config.pick_bar and config.pick_bar(active))
			or (active and "active" or "inactive")
	end

	return function()
		local active = vim.g.statusline_winid == vim.fn.win_getid()
		local which = vim.api.nvim_win_call(vim.g.statusline_winid, function() return pick_bar(active) end)

		local bar = config.bars[which]
		return vim.api.nvim_win_call(vim.g.statusline_winid, function()
			return M.render(bar)
		end)
	end
end

-- Powerline ------------------------------------------------------------------
M.powerline = {}

-- unicode
M.powerline.light_horizontal = "─"
M.powerline.heavy_horizontal = "━"
M.powerline.light_dashed_horizontal = "╌"
M.powerline.heavy_dashed_horizontal = "╍"
M.powerline.heavy_left = ""
M.powerline.heavy_right = ""
M.powerline.light_left = ""
M.powerline.light_right = ""

-- TODO more comprehensive special-casing of "" segments

---@type vimrc.hemlime.SepFn
function M.powerline.sep_right(l, r, props)
	local rpad = r.content ~= "" and " " or ""
	if r.hl.bg == l.hl.bg then
		return {
			{ content = " " .. M.powerline.light_right .. rpad, hl = { fg = props.hl.fg, bg = l.hl.bg } },
		}
	else
		return {
			{ content = " ", hl = { bg = l.hl.bg } },
			{ content = M.powerline.heavy_right .. rpad, hl = { bg = r.hl.bg, fg = l.hl.bg } },
		}
	end
end

---@type vimrc.hemlime.SepFn
function M.powerline.sep_left(l, r, props)
	local lpad = l.content ~= "" and " " or ""
	if r.hl.bg == l.hl.bg then
		return {
			{ content = lpad .. M.powerline.light_left .. " ", hl = { fg = props.hl.fg, bg = l.hl.bg } },
		}
	else
		return {
			{ content = lpad .. M.powerline.heavy_left, hl = { bg = l.hl.bg, fg = r.hl.bg } },
			{ content = " ", hl = { bg = r.hl.bg } },
		}
	end
end

function M.powerline.lcap(ch)
	return {
		"",
		ch,
		sep = function(_, r, props)
			if r.hl.bg == props.hl.bg then return {} end
			return {
				{ content = M.powerline.heavy_left, hl = { fg = r.hl.bg, bg = props.hl.bg } },
				{ content = " ", hl = r.hl },
			}
		end,
	}
end

function M.powerline.rcap(ch)
	return {
		ch,
		"",
			sep = function(l, _, props)
				if l.hl.bg == props.hl.bg then return {} end
				return {
					{ content = " ", hl = l.hl },
					{ content = M.powerline.heavy_right, hl = { fg = l.hl.bg, bg = props.hl.bg } },
				}
			end,
	}
end

function M.powerline.lrcap(x)
	return M.powerline.lcap(M.powerline.rcap(x))
end

return M
