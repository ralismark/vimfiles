local cmp = require "cmp"

local const = function(x) return function() return x end end

cmp.register_source("hr", {
	is_available = const(true),
	get_debug_name = const("hr"),
	get_keyword_pattern = const([[\([-=_]\)\1\{4,}]]),
	complete = function(self, params, callback)
		local startcol = params.context:get_offset(self:get_keyword_pattern())
		if startcol == params.context.cursor.col then
			return
		end

		local len = 80 - startcol
		callback({
			{ label = ("-"):rep(len) },
			{ label = ("="):rep(len) },
			{ label = ("_"):rep(len) },
		})
	end,
})

local kind_icons = {
	--  ⮺ ⎆⎗⎘⎌
	Text          = "𝐓",
	Method        = "ƒ",
	Function      = "ƒ",
	Constructor   = "ƒ",
	Field         = "□",
	Variable      = "□",
	Class         = "◇",
	Interface     = "◇",
	Module        = "ꖸ",
	Property      = "?Property",
	Unit          = "?Unit",
	Value         = "?Value",
	Enum          = "◇",
	Keyword       = "⌘",
	Snippet       = "⛶",
	Color         = "?Color",
	File          = "🖹",
	Reference     = "↶",
	Folder        = "🗀",
	EnumMember    = "π",
	Constant      = "π",
	Struct        = "◇",
	Event         = "",
	Operator      = "◯",
	TypeParameter = "◇",
}


cmp.setup {
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			require "luasnip".lsp_expand(args.body)
		end,
	},
	mapping = {
	},
	sources = cmp.config.sources({
		{ name = "hr" },
		{ name = "cody" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
		{ name = "buffer", keyword_length = 5 },
	}),
	view = {
		entries = "native",
	},
	formatting = {
		format = function(entry, vim_item)
			-- TODO does this depend on the specific cmp+luasnip plugin we use?
			if entry.source.name == "luasnip" then
				local snip = require "luasnip".get_id_snippet(entry:get_completion_item().data.snip_id)
				vim_item.menu = snip.name or vim_item.abbr
			end
			-- vim_item.kind = kind_icons[vim_item.kind]
			return vim_item
		end,
	},
	completion = {
	},
}

