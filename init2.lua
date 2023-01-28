-- vim: set foldmethod=marker:

-- Primary neovim initialisation
--
-- This can be renamed to init.lua if/when everything from
-- init.vim gets ported here

local augroup = vim.api.nvim_create_augroup("vimrc_init2", {clear = true})

-- Plugins {{{1

-- require "nvim-treesitter.configs".setup {
-- 	ensure_installed = {
-- 	},
-- }

require "vimrc.packctl".setup {

	["plugin:nvim-lspconfig"] = function() end,
	["plugin:vim-eunuch"] = function() -- {{{
		vim.g.eunuch_no_maps = 1
	end, -- }}}
	["plugin:vim-polyglot"] = function() -- {{{
		vim.g.did_cpp_syntax_inits = 1
		vim.g.polyglot_disabled = {
			"latex",
			"protobuf",
			"sensible", -- does shortmess=+A
		}
	end, -- }}}
	["plugin:vim-easy-align"] = function() -- {{{
		-- Start interactive EasyAlign in visual mode (e.g. vipga)
		vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", {
			remap = true,
		})

		-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
		vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", {
			remap = true,
		})

		vim.g.easy_align_delimiters = {
			t = {
				pattern = "\\t",
				left_margin = 0,
				right_margin = 0,
				stick_to_left = 1,
			},
		}
	end, -- }}}
	["plugin:nvim-lightbulb"] = function() -- {{{
		require "nvim-lightbulb".setup {
			sign = {
				enabled = true,
				priority = 20,
			},
			autocmd = {
				enabled = false,
			},
		}

		vim.cmd([[
			augroup vimrc_lightbulb
				au!
				au CursorHold,CursorHoldI * lua require "nvim-lightbulb".update_lightbulb()
			augroup END
		]])
	end, -- }}}
	["plugin:vim-replacewithregister"] = function() -- {{{
		vim.keymap.set("n", "s", "<Plug>ReplaceWithRegisterOperator")
		vim.keymap.set("n", "ss", "<Plug>ReplaceWithRegisterLine")
		vim.keymap.set("x", "s", "<Plug>ReplaceWithRegisterVisual")
	end, -- }}}
	["plugin:editorconfig-vim"] = function() -- {{{
		vim.g.EditorConfig_exclude_patterns = {
			".*/\\.git/.*", -- ignore things inside git repo
		}
	end, -- }}}

	-- ["extern:packadd-name"] = function()
	-- end,

}

-- LSP Config {{{2

local lspconfig = require "lspconfig"

lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		capabilities = require "cmp_nvim_lsp".update_capabilities(
			vim.lsp.protocol.make_client_capabilities()
		),
		handlers = {
			["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					focusable = false
				}
			)
		},
	}
)

lspconfig.pylsp.setup {
	settings = {
		pyls = {
			plugins = {
				pylint = { enabled = true },
				yapf = { enabled = false },
			},
		},
	},
}

lspconfig.rust_analyzer.setup {
}

lspconfig.clangd.setup {
}

lspconfig.jdtls.setup {
	cmd = {
		"/usr/bin/java", -- BUGFIX this needs to be at least java17, dotenv can cause this to be older so use global one <2022-07-10>
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dosgi.checkConfiguration=true",
		"-Dosgi.sharedConfiguration.area=/usr/share/java/jdtls/config_linux",
		"-Dosgi.sharedConfiguration.area.readOnly=true",
		"-Dosgi.configuration.cascaded=true",
		-- "-Dlog.protocol=true",
		-- "-Dlog.level=ALL",
		"-noverify",
		"-Xms512M",
		"-Xmx1G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", vim.fn.glob("/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-data", vim.env.JDTLS_WORKSPACE or "/tmp/jdtls-workspace",
	}
}

lspconfig.gopls.setup {
	cmd = { "gopls", "-remote=auto" },
}

lspconfig.sumneko_lua.setup {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}

-- vim.cmd [[ packadd isabelle ]]
-- lspconfig.isabelle.setup {}

local null_ls = require "null-ls"
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.shellcheck,
	},
})

require "lsp_signature".setup {
	floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
	doc_lines = 0,
	handler_opts = {
		border = "none",
	},

	hint_enable = false, -- virtual hint enable
	hint_prefix = "◇ ",
	hint_scheme = "LspParameterHint",
}

-- nvim-cmp {{{2

require "cmp".register_source("hr", require "vimrc.nvim-cmp-hr")

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

require "cmp".setup {
	preselect = require "cmp".PreselectMode.None,
	snippet = {
		expand = function(args)
			require "luasnip".lsp_expand(args.body)
		end,
	},
	mapping = {
	},
	sources = require "cmp".config.sources({
		{ name = "hr" },
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

-- luasnip {{{2

require "luasnip.loaders.from_vscode".lazy_load()

require "vimrc.luasnip"

-- telescope {{{2

require "telescope".setup {
	defaults = {
		-- sorting_strategy = "ascending",
	},
}

vim.keymap.set("n", "<leader><leader>b", function()
	require "telescope.builtin".buffers {
		sort_mru = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	require "vimrc.telescope_live_file" {
	-- require "telescope.builtin".find_files {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
		sorter = require "telescope.sorters".get_fuzzy_file(),
	}
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
	}
end)

-- guess-indent {{{2

require "guess-indent".setup {
	auto_cmd = true,
}

-- local {{{2

require "vimrc.diagnostic".setup {
}

-- Statusline {{{1

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

-- Other vimrc modules {{{1

vim.api.nvim_create_autocmd("BufNewFile", {
	group = augroup,
	pattern = "*",
	desc = "vimrc.skeletons",
	callback = (require "vimrc.skeletons").expand,
})

-- Bindings {{{1

vim.keymap.set("n", "<c-g>", function()
	local msg = require "vimrc.git_blame".blame()
	if msg ~= nil then
		print(msg)
	end
end)

vim.keymap.set("i", "<c-r>!", [[<c-r>=system(input("!", "", "shellcmd"))<cr>]])
