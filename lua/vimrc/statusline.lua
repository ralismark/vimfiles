-- This file contains functionality for statusline and
-- tabline

-- function filename()
-- 	local name = vim.fn.bufname()
-- end

local M = {}

-- <=a=<=b=> c <-----> x <=y=>=z=>
function M.make_status(config)
	local parts
	local co
	local sep
	if vim.g.statusline_winid == vim.fn.win_getid() then
		parts = config.active
		co = { "%1*", "%2*", "%3*", "%4*" }
		sep = "━"
	else
		parts = config.inactive
		co = { "%6*", "%7*", "%8*", "%9*" }
		sep = "─"
	end

	------------------

	local st = ""

	st = st .. co[2] .. "" .. co[1] .. " "

	local function get_content(x, colour)
		if type(x) == "string" then
			x = config.components[x]
		end
		if x == nil then
			return nil
		end
		if type(x) == "function" then
			x = { content = x }
		end
		if type(x) ~= "table" then
			error "component is not a table"
		end

		if x.visible ~= nil and x.visible() then
			return nil
		end
		local c = vim.api.nvim_win_call(vim.g.statusline_winid, x.content)
		if c ~= nil then
			c = c:gsub("%%", "%%%%")
		else
			return nil
		end

		if x.color ~= nil then
			c = "%#" .. x.color .. "#" .. c .. colour
		end
		return c
	end

	for _, item in ipairs(parts.a) do
		local c = get_content(item, co[1])
		if c ~= nil then
			st = st .. c .. "  "
		end
	end

	local first_b = true
	for _, item in ipairs(parts.b) do
		local c = get_content(item, co[1])
		if c ~= nil then
			if first_b then
				first_b = false
			else
				st = st .. " "
			end
			st = st .. c .. " "
		end
	end

	st = st .. co[2] .. " " .. co[3]

	local first_c = true
	for _, item in ipairs(parts.c) do
		local c = get_content(item, co[3])
		if c ~= nil then
			if first_c then
				first_c = false
			else
				st = st .. " "
			end
			st = st .. c .. " "
		end
	end

	st = st .. co[4] .. "%<" .. sep:rep(vim.fn.winwidth(vim.g.statusline_winid)) .. "> " .. co[3]

	local first_x = true
	for _, item in ipairs(parts.x) do
		local c = get_content(item, co[3])
		if c ~= nil then
			if first_x then
				first_x = false
			else
				st = st .. " "
			end
			st = st .. c .. " "
		end
	end

	st = st .. co[2] .. "" .. co[1] .. " "

	local first_y = true
	for _, item in ipairs(parts.y) do
		local c = get_content(item, co[1])
		if c ~= nil then
			if first_y then
				first_y = false
			else
				st = st .. " "
			end
			st = st .. c .. " "
		end
	end

	for _, item in ipairs(parts.z) do
		local c = get_content(item, co[1])
		if c ~= nil then
			st = st .. " " .. c .. " "
		end
	end

	st = st .. co[2] .. "" .. co[1]

	return st
end

function M.statusline()
	return "nil"
end

function M.setup(config)
	M.statusline = function()
		return M.make_status(config)
	end
	vim.g.qf_disable_statusline = true
	vim.go.statusline = [[%!luaeval('require"vimrc.statusline".statusline()')]]
end

return M
