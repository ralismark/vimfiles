---@class HighlightParams
---@field fg string?
---@field bg string?
---@field bold boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field underdouble boolean?
---@field underdotted boolean?
---@field underdashed boolean?
---@field reverse boolean?
---@field italic boolean?
---@field standout boolean?

---All attributes that a highlight group can have, see :h attr-list.
local attrs = {
	"bold",
	"underline",
	"undercurl",
	"underdouble",
	"underdotted",
	"underdashed",
	"reverse",
	"italic",
	"standout",
}

---@param hl HighlightParams
---@return string
local function name_hl(hl)
	local s = ("%s_%s"):format(hl.fg or "", hl.bg or ""):gsub("#", "hex")
	for _, attr in ipairs(attrs) do
		if hl[attr] then
			s = s .. "_" .. attr
		end
	end
	return s
end

---@param hl HighlightParams
---@return table
local function parse_hl(hl)
	local fixed = {}
	fixed.ctermfg = hl.fg
	fixed.ctermbg = hl.bg
	for _, attr in ipairs(attrs) do
		if hl[attr] then
			fixed[attr] = true
		end
	end
	return fixed
end

---@class Highlighter
---@field finish fun()
---@field register fun(hl: HighlightParams): string

---Create a new dynamic highlight manager.
---@param prefix string Prefix for highlight groups
---@return Highlighter
local function new_highlighter(prefix)
	---@type table<string, table>
	local defined_highlights = {}

	vim.api.nvim_create_autocmd({ "ColorScheme" }, {
		desc = "vimrc.highlighter: restore highlights for " .. prefix,
		callback = function()
			for name, hl in pairs(defined_highlights) do
				vim.api.nvim_set_hl(0, name, hl)
			end
		end,
	})

	return {
		finish = function()
		end,

		---@param hl HighlightParams
		register = function(hl)
			local name = prefix .. "_" .. name_hl(hl)
			if not defined_highlights[name] then
				local parsed = parse_hl(hl)
				vim.api.nvim_set_hl(0, name, parsed)
				defined_highlights[name] = parsed
			end
			return name
		end,
	}
end

return new_highlighter
