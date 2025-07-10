local ls = require "luasnip"
require "luasnip.loaders.from_vscode".lazy_load()
ls.setup {
	enable_autosnippets = true,
}

-- Luasnip abbreviations
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local rep = require("luasnip.extras").rep

ls.add_snippets("python", {
	s("logging.basicConfig", {
		t({
			"logging.basicConfig(",
			"    format=\"%(asctime)s.%(msecs)03d [%(levelname)s] [%(name)s:%(lineno)d] %(message)s\",",
			"    datefmt=\"%Y%m%d:%H:%M:%S\",",
			"    level=logging.INFO",
			")",
		}),
	}),
	s("main", {
		t({
			"if __name__ == \"__main__\":",
			"    ",
		})
	}),
})

local function java_parse_signature()
	-- Get enough lines to include the whole signature.
	local cursor_linenum = vim.api.nvim_win_get_cursor(0)[1]
	local lines = table.concat(vim.api.nvim_buf_get_lines(0, cursor_linenum, cursor_linenum + 10, false))
	local brace, _ = lines:find("{")
	if brace == nil then
		return nil
	end

	lines = lines:sub(0, brace - 1):gsub("^%s+", "")

	local consume = function(pat)
		local s, e = lines:find("^" .. pat)
		if s == nil then
			return nil
		end
		local extracted = lines:sub(s, e)
		lines = lines:sub(e+1)
		return extracted
	end

	-- Extract method modifier
	local access = "default"
	local static = false
	local final = false
	local abstract = false
	while true do
		-- TODO still missing some
		if consume("public%s+") then
			access = "public"
		elseif consume("private%s+") then
			access = "private"
		elseif consume("protected%s+") then
			access = "protected"
		elseif consume("static%s+") then
			static = true
		elseif consume("abstract%s+") then
			abstract = true
		elseif consume("final%s+") then
			final = true
		end
		break
	end

	-- Extract type
	local function consume_type()
		local typ = consume("[A-Za-z_][A-Za-z0-9_]*")
		while true do
			local path = consume("%s*%.%s*[A-Za-z_][A-Za-z0-9_]*")
			if path then
				typ = typ .. path
			else
				break
			end
		end

		local open_type_param = consume("%s*<%s*")
		if open_type_param then
			typ = typ .. open_type_param

			-- type param list
			while true do
				local tparam = consume_type()
				if tparam == nil then
					return nil
				end
				typ = typ .. tparam

				local comma = consume("%s*,%s*")
				if comma then
					typ = typ .. comma
				else
					break
				end
			end

			local close_type_param = consume("%s*>")
			if close_type_param == nil then
				return nil
			end
			typ = typ .. close_type_param
		end

		while true do
			local array = consume("%s*%[%s*%]")
			if array then
				typ = typ .. array
			else
				break
			end
		end
		return typ
	end

	local rtype = consume_type()
	if rtype == nil then
		return nil
	end

	local name = ""

	local constructor = false
	if consume("%s*%(") then
		-- must be constructor
		if not rtype:match("^[A-Za-z_][A-Za-z0-9_]*$") then
			return nil
		end
		constructor = true
		name = rtype
		rtype = "void"
	else
		name = consume("%s+[A-Za-z_][A-Za-z0-9_]*")
		if not name then
			return nil
		end
		name = name:gsub("^%s+", "")

		if not consume("%s*%(") then
			return nil
		end
	end

	-- parse arg list
	local args = {}
	if not consume("%s*%)") then
		while true do
			consume("%s+")
			local typ = consume_type()
			if not typ then
				return nil
			end
			consume("%s+")
			local ident = consume("[A-Za-z_][A-Za-z0-9]*")
			if not ident then
				return nil
			end
			table.insert(args, { t = typ, name = ident })

			if consume("%s*%)") then
				break
			elseif not consume("%s*,") then
				return nil
			end
		end
	end

	-- TODO check for trailing attributes
	-- TODO check that the remaining content is empty

	return {
		access = access,
		static = static,
		final = final,
		abstract = abstract,
		constructor = constructor,

		rtype = rtype,
		name = name,
		args = args,
		lines = lines,
	}
end

local function jsdoc_snippet()
	local sig = java_parse_signature()
	if sig == nil then
		return sn(nil, {})
	end

	local parts = {
		t({ "", " *" }),
	}
	for j, item in ipairs(sig.args) do
		table.insert(parts, t({ "", " * @param " .. item.name .. " " }))
		table.insert(parts, i(j))
	end
	if sig.rtype ~= "void" then
		table.insert(parts, t({ "", " * @return " }))
		table.insert(parts, i(#sig.args))
	end

	print(parts)

	return sn(nil, parts)
end

ls.add_snippets("java", {
	s({
		trig = "/**",
		name = "Generate JavaDoc",
	}, {
		t({ "/**", " * " }),
		i(1, "A short description"),
		d(2, jsdoc_snippet),
		t({ "", " */" }),
	},{
		show_condition = function(line_to_cursor)
			-- local l, c = unpack(vim.api.nvim_win_get_cursor(0))
			-- local nextline = vim.fn.getline(l+1)
			-- local nextline = vim.api.nvim_buf_get_lines(0, l, l+1, true)[1]
			return line_to_cursor:match("^%s*/%*%*$")
		end,
	}),
	s({
		trig = "/*g",
		name = "Generate JavaDoc for getter",
	}, {
		t({ "/**", " * Get " }),
		i(1, "the attribute"),
		t({ "", " *", " * @return " }),
		rep(1),
		t({ "", " */" }),
	}),
	s({
		trig = "/*s",
		name = "Generate JavaDoc for getter",
	}, {
		t({ "/**", " * Set the " }),
		i(2, "attribute"),
		t({ "", " *", " * @param " }),
		i(1, "-"),
		t({ " the new " }),
		rep(2),
		t({ "", " */" }),
	})
})

ls.add_snippets("all", {
	s({
		name = "modeline",
		trig = "vim:",
		snippetType = "autosnippet",
		condition = function()
			local linenr = vim.fn.line(".")
			local total_lines = vim.fn.line("$")
			return linenr <= vim.o.modelines or linenr > total_lines - vim.o.modelines
		end,
	}, {
		t({"vim: set "}), i(0), t({":"}),
	}),
})
