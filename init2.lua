-- vim: set foldmethod=marker foldlevel=0:

-- Primary neovim initialisation
--
-- This can be renamed to init.lua if/when everything from
-- init.vim gets ported here

local augroup = vim.api.nvim_create_augroup("vimrc_init2", {clear = true})

---@diagnostic disable-next-line: lowercase-global
const = function(x) return function() return x end end

-- Plugins {{{1

-- require "nvim-treesitter.configs".setup {
-- 	ensure_installed = {
-- 	},
-- }

require "vimrc.packctl".setup {

	["plugin:vim-dispatch"] = function() -- {{{
		vim.g.dispatch_no_maps = true
	end, -- }}}
	["plugin:goyo.vim"] = function() -- {{{
		vim.g.goyo_width = 90
	end, -- }}}
	["plugin:vim-eunuch"] = function() -- {{{
		vim.g.eunuch_no_maps = 1
	end, -- }}}
	-- ["plugin:vim-polyglot"] = function() -- {{{
	-- 	vim.g.did_cpp_syntax_inits = 1
	-- 	vim.g.polyglot_disabled = {
	-- 		"latex",
	-- 		"protobuf",
	-- 		"sensible", -- does shortmess=+A
	-- 	}
	-- end, -- }}}
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

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = augroup,
			desc = "require\"nvim-lightbulb\".update_lightbulb()",
			callback = function()
				require "nvim-lightbulb".update_lightbulb()
			end,
		})
	end, -- }}}
	["plugin:vim-replacewithregister"] = function() -- {{{
		vim.keymap.set("n", "s", "<Plug>ReplaceWithRegisterOperator")
		vim.keymap.set("n", "ss", "<Plug>ReplaceWithRegisterLine")
		vim.keymap.set("x", "s", "<Plug>ReplaceWithRegisterVisual")
	end, -- }}}
	["plugin:editorconfig-vim"] = function() -- {{{
		vim.g.EditorConfig_exclude_patterns = {
			".*/\\.git/.*", -- don't apply to git-internal things e.g. commit message
		}
	end, -- }}}
	["plugin:LuaSnip"] = function() -- {{{
		require "luasnip.loaders.from_vscode".lazy_load()
		require "vimrc.luasnip"
	end, -- }}}
	["plugin:guess-indent.nvim"] = function() -- {{{
		require "guess-indent".setup {
			auto_cmd = true,
		}
	end, -- }}}

}

-- nvim-cmp {{{2

require "cmp".register_source("hr", {
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

-- telescope {{{2

require "telescope".setup {
	defaults = {
		vimgrep_arguments = {
			"grep",
			"--extended-regexp",
			"--color=never",
			"--with-filename",
			"--line-number",
			"-b", -- grep doesn't support a `--column` option :(
			"--ignore-case",
			"--recursive",
			"--no-messages",
			"--exclude-dir=*cache*",
			"--exclude-dir=*.git",
			"--exclude=.*",
			--"--binary-files=without-match",
		},
		-- sorting_strategy = "ascending",
	},
}

vim.keymap.set("n", "<leader><leader>b", function()
	require "telescope.builtin".buffers {
		sort_mru = true,
	}
end)

vim.keymap.set("n", "<leader><leader>f", function()
	require "telescope.builtin".find_files {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
	}
	--[[
	local conf = require("telescope.config").values
	local opts = {
		cwd = require "lspconfig".util.find_git_ancestor(vim.fn.getcwd()),
		sorter = require "telescope.sorters".get_fuzzy_file(),
		entry_maker = require "telescope.make_entry".gen_from_file({})
	}

	local finder = require "telescope.finders".new_oneshot_job(
		{
			"find", ".",
			-- "-L", -- follow symlinks
			"-name", ".?*", "-prune", "-o", -- ignore hidden files
			"-type", "f",
			"-print",
		},
		opts
	)

	require "telescope.pickers".new(opts, {
		prompt_title = "Find Files",
		finder = finder,
		previewer = conf.file_previewer(opts),
		sorter = conf.generic_sorter(opts)
	}):find()
	]]
end)

vim.keymap.set("n", "<leader><leader>g", function()
	require "telescope.builtin".live_grep {
	}
end)

-- local {{{2

vim.api.nvim_create_autocmd("BufNewFile", {
	group = augroup,
	pattern = "*",
	desc = "vimrc.skeletons",
	callback = (require "vimrc.skeletons").expand,
})


-- LSP {{{1

-- Language servers {{{2

local lspconfig = require "lspconfig"

lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		capabilities = require "cmp_nvim_lsp".default_capabilities(),
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
	cmd = {
		"nix", "shell", "nixpkgs#python3Packages.python-lsp-server", "-c",
		"pylsp",
	},
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
		"nix", "run", "nixpkgs#jdt-language-server", "--",
		"-Xms512M",
		"-Xmx1G",
		"-data", vim.env.JDTLS_WORKSPACE or "/tmp/jdtls-workspace",
	},
	root_dir = function(fname)
		return (
			lspconfig.util.find_git_ancestor(fname)
			or lspconfig.util.root_pattern("build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts", ".project", ".classpath")(fname)
			or lspconfig.util.root_pattern("build.gradle", "build.gradle.kts")
		)
	end,
}

lspconfig.gopls.setup {
	cmd = { "gopls", "-remote=auto" },
}

lspconfig.lua_ls.setup {
	cmd = {
		"nix", "run", "nixpkgs#lua-language-server", "--",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.list_extend({ "lua/?.lua", "lua/?/init.lua", }, vim.split(package.path, ";")),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
}

lspconfig.nil_ls.setup {
	cmd = {
		"nix", "run", "nixpkgs#nil", "--",
	},
}

local null_ls = require "null-ls"
null_ls.setup {
	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.shellcheck.with({
			command = function()
				if vim.fn.executable("shellcheck") > 0 then
					return "shellcheck"
				end

				local drv = nil
				local jobid = vim.fn.jobstart(
					{"nix", "build", "--no-link", "--json", "nixpkgs#shellcheck" },
					{
						stdout_buffered = true,
						on_stdout = function(chan_id, data, name)
							drv = vim.fn.json_decode(data)
						end,
					}
				)
				vim.fn.jobwait({ jobid })

				return drv[1].outputs.bin .. "/bin/shellcheck"
			end,
		}),
	},
}

-- UI {{{2

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = augroup,
	desc = "vim.diagnostic.open_float",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
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

require "vimrc.diagnostic".setup {
}

-- TODO: Switch to using numhl when neovim v0.7 gets released <2022-03-18>
--       This is blocked on neovim/neovim#16914 'don't put empty sign text in line number column'
vim.cmd([[
sign define DiagnosticSignError text=✕ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn  text=▲ texthl=DiagnosticSignWarn  linehl= numhl=
sign define DiagnosticSignInfo  text=◆ texthl=DiagnosticSignInfo  linehl= numhl=
sign define DiagnosticSignHint  text=🞶 texthl=DiagnosticSignHint  linehl= numhl=
]])

-- Binds {{{2

vim.api.nvim_create_user_command("LspDebug", function()
	vim.lsp.set_log_level(vim.log.levels.DEBUG)
end, {
	nargs = 0,
	desc = "vim.lsp.set_log_level(vim.log.levels.DEBUG)",
})

vim.api.nvim_create_user_command("LspFormat", function() vim.lsp.buf.formatting_sync() end, {
	nargs = 0,
	desc = "vim.lsp.buf.formatting_sync()",
})

vim.api.nvim_create_user_command("LspRename", function(params)
	vim.lsp.buf.rename(params.args)
end, {
	nargs = 1,
	desc = "vim.lsp.buf.rename(...)",
})

-- TODO add a timeout to these <2022-07-10>
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "vim.lsp.buf.declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "vim.lsp.buf.implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "vim.lsp.buf.references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "vim.lsp.buf.hover" })
vim.keymap.set("n", "H", vim.lsp.buf.code_action, { desc = "vim.lsp.buf.code_action" })
vim.keymap.set("x", "H", vim.lsp.buf.range_code_action, { desc = "vim.lsp.buf.range_code_action" })

-- Terminal {{{1

vim.keymap.set("t", "<esc>", [[<c-\><c-n>]])

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = augroup,
	callback = function()
		-- IPC compatibility for nvr
		vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername
		-- no gutter
		vim.cmd [[
		setl nonumber
		setl norelativenumber
		]]
	end,
})

-- UI {{{1

-- Statusline {{{2

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

-- Tabline {{{2

--[[
_G.tabline = function()
	local s = ""

	for i = 1, vim.fn.tabpagenr("$") do
		if i > 1 then
			s = s .. " "
		end
	end
end
]]

-- Colours {{{2

vim.cmd("colorscheme duality")

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	group = augroup,
	desc = "colorscheme patches",
	callback = function()
		vim.cmd [[
			hi pandocHTMLComment ctermbg=245 ctermfg=192 cterm=none
		]]
	end,
})

vim.api.nvim_create_autocmd({ "Syntax" }, {
	group = augroup,
	desc = "syntax patches",
	callback = function()
		vim.cmd [[
			syntax match ConflictMarker containedin=ALL /^\(<<<<<<<\|=======\||||||||\|>>>>>>>\).*/
			hi def link ConflictMarker Error

			" PEP 350 Codetags (https://www.python.org/dev/peps/pep-0350/)
			syn keyword Codetag contained containedin=.*Comment.*
				\ TODO MILESTONE MLSTN DONE YAGNI TDB TOBEDONE
				\ FIXME XXX DEBUG BROKEN REFACTOR REFACT RFCTR OOPS SMELL NEEDSWORK INSPECT
				\ BUG BUGFIX
				\ NOBUG NOFIX WONTFIX DONTFIX NEVERFIX UNFIXABLE CANTFIX
				\ REQ REQUIREMENT STORY
				\ RFE FEETCH NYI FR FTRQ FTR
				\ IDEA
				\ QUESTION QUEST QSTN WTF
				\ ALERT
				\ HACK CLEVER MAGIC
				\ PORT PORTABILITY WKRD
				\ CAVEAT CAV CAVT WARNING CAUTION
				\ NOTE HELP
				\ FAQ
				\ GLOSS GLOSSARY
				\ SEE REF REFERENCE
				\ TODOC DOCDO DODOC NEEDSDOC EXPLAIN DOCUMENT
				\ CRED CREDIT THANKS
				\ STAT STATUS
				\ RVD REVIEWED REVIEW
				\ SAFETY
			hi def link Codetag Todo
		]]
	end,
})

-- Options {{{1

vim.g.man_hardwrap = false

-- UI/Editor {{{2

vim.opt.timeout = false
vim.opt.matchpairs:append("<:>")
vim.opt.lazyredraw = true
vim.opt.shortmess = "nxcIT"

-- splits
vim.opt.splitright = true

-- Status line
vim.opt.laststatus = 2
vim.opt.showmode = true
vim.opt.showtabline = 1
vim.opt.showcmd = true

-- Scrolling
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8

-- Completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.complete = ".,w,b,t"
vim.opt.completeopt = "menu,menuone,noinsert,noselect"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Replacing stuff
vim.opt.inccommand = "nosplit"

-- No bells/flash
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.belloff = "all"

-- Conceal
vim.opt.conceallevel = 1
vim.opt.concealcursor = ""

-- Hidden chars
vim.opt.list = true
vim.opt.listchars = "tab:│ ,extends:›,precedes:‹,nbsp:⎵,trail:∙"
vim.opt.fillchars = "eob: ,fold:─,stl: ,stlnc: ,diff:-,foldopen:╒,foldclose:═"

-- Line wrapping
vim.opt.wrap = false -- toggle with <leader>ow
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- Folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 999 -- open everything initially

-- Mouse
vim.opt.mouse = "a"

-- c-a and c-x
vim.opt.nrformats = "alpha,unsigned"

-- Key over lines
vim.opt.backspace = "indent,eol,start,nostop"
vim.opt.whichwrap = "b,s,<,>,[,]"

-- Allow cursor to go anywhere in visual block mode
vim.opt.virtualedit = "block"

-- Gutter
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "number"

-- Behaviour {{{2

vim.opt.shada = "!,'64,/16,<50,f1,h,s10"
vim.opt.fixeol = false -- don't make unnecessary changes
vim.opt.hidden = false -- drop buffers after they're closed
vim.opt.diffopt:append { "algorithm:patience", "indent-heuristic" }

if vim.fn.executable("rg") > 0 then
	vim.opt.grepprg = "rg --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m"
elseif vim.fn.executable("ag") > 0 then
	vim.opt.grepprg = "ag --nogroup --nocolor --column"
	vim.opt.grepformat = "%f:%l:%c%m"
else
	vim.opt.grepprg = "grep -rn"
	vim.opt.grepformat = "%f:%l:%m"
end

-- Shell things
-- TODO are these still relevant? <2023-02-24>
vim.opt.shell = vim.env.SHELL
vim.opt.shellslash = true
vim.opt.shellpipe = "2>&1 | tee"

-- Automate/persistence
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.undofile = true
vim.opt.updatetime = 1000

-- Spelling
vim.opt.spelllang = "en_au,en_us"
vim.opt.spelloptions = "camel"
vim.opt.spellsuggest = "fast,8"

-- Bindings {{{1

local function interp(x) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(x, true, false, true), "n", false) end

local function ifwrap(a, b)
	return function()
		if vim.o.wrap then
			return interp(a)
		else
			return interp(b)
		end
	end
end

-- Multitools {{{2

local luasnip = require "luasnip"
local cmp = require "cmp"

local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- these can't be <expr> maps since inserting text is forbidden while evaluating the map

vim.keymap.set({ "i", "s" }, "<tab>", function()
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_locally_jumpable() then
		luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		interp("<Tab>")
	end
end)

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.in_snippet() and luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		interp("<Tab>")
	end
end)

vim.keymap.set({ "i", "s"}, "<cr>", function()
	if cmp.get_selected_entry() ~= nil then
		cmp.confirm()
	else
		interp("<cr>")
	end
end)

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if cmp.get_selected_entry() ~= nil then
		cmp.confirm()
		return
	end
	if cmp.visible() then
		cmp.close()
	end
	if luasnip.expand_or_locally_jumpable() then
		luasnip.expand_or_jump()
	end
end)

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if luasnip.in_snippet() and luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		return interp("<c-k>")
	end
end)

vim.keymap.set({ "n", "x" }, "<return>", function()
	local man_url = "man://"
	if vim.bo.buftype == "help" or vim.fn.expand("%:p"):sub(1, #man_url) == man_url then
		return interp("<c-]>")
	elseif vim.bo.buftype == "quickfix" then
		return interp("<cr>")
	else
		return interp("@q")
	end
end)

-- vim.keymap.set("i", "<space>", function()
-- 	if cmp.visible() then
-- 		cmp.confirm()
-- 	end
-- 	interp("<space>")
-- end)

-- Leader {{{2

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>", "<nop>")
vim.keymap.set("n", "<leader>r", [[<cmd>mode | syntax sync fromstart<cr>]])

-- Toggles
vim.keymap.set("n", "<leader>o", "<nop>")
vim.keymap.set("n", "<leader>ou", [[<cmd>UndotreeToggle<cr><c-w>999h]])
vim.keymap.set("n", "<leader>og", [[<cmd>Goyo<cr>ze]])
vim.keymap.set("n", "<leader>ow", [[<cmd>set wrap! | set wrap?<cr>]])
vim.keymap.set("n", "<leader>os", [[<cmd>set spell! | set spell?<cr>]])
vim.keymap.set("n", "<leader>on", [[<cmd>set relativenumber! | set relativenumber?<cr>]])
vim.keymap.set("n", "<leader>od", [[<cmd>if &diff | diffoff | else | diffthis | endif | set diff?<cr>]])
vim.keymap.set("n", "<leader>oq", [[<cmd>if getqflist({"winid":0}).winid | cclose | else | botright copen | endif<cr>]])
vim.keymap.set("n", "<leader>ol", [[<cmd>if getloclist(0, {"winid":0}).winid | lclose | else | botright lopen | endif<cr>]])

-- Splits
vim.keymap.set("n", "<leader>s", "<nop>")
vim.keymap.set("n", "<leader>ss", "<c-w>s")
vim.keymap.set("n", "<leader>sv", "<c-w>v")
vim.keymap.set("n", "<leader>sh", "<cmd>aboveleft vertical new<cr>")
vim.keymap.set("n", "<leader>sl", "<cmd>belowright vertical new<cr>")
vim.keymap.set("n", "<leader>sj", "<cmd>belowright horizontal new<cr>")
vim.keymap.set("n", "<leader>sk", "<cmd>aboveleft horizontal new<cr>")

vim.keymap.set("n", "<leader>t", "<cmd>tab new<cr>")

-- Better Defaults {{{2

-- better binds
vim.keymap.set({ "n", "x" }, ";", ":")
vim.keymap.set({ "n", "x" }, ",", ";")
vim.keymap.set({ "n", "x" }, "'", "`")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "&", "<cmd>&&<cr>")
vim.keymap.set("x", "&", [[<c-\><c-n><cmd>'<,'>&&<cr>]])
vim.keymap.set("x", "p", "P")

-- wrapping (logical lines)
vim.keymap.set({ "n", "x" }, "0", ifwrap("g0", "0"))
vim.keymap.set({ "n", "x" }, "G", ifwrap("G$g0", "G"))
vim.keymap.set({ "n", "x" }, "$", ifwrap("g$", "$"))
vim.keymap.set({ "n", "x" }, "j", function() if vim.v.count == 0 then return "gj" else return "j" end end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function() if vim.v.count == 0 then return "gk" else return "k" end end, { expr = true })

-- visual mode improvements
vim.keymap.set("x", "I", function()
	if vim.fn.mode() == "v" then
		return interp("<c-v>I")
	elseif vim.fn.mode() == "V" then
		return interp("<c-v>^o^I")
	else
		return interp("I")
	end
end)
vim.keymap.set("x", "A", function()
	if vim.fn.mode() == "v" then
		return interp("<c-v>A")
	elseif vim.fn.mode() == "V" then
		return interp("<c-v>Oo$A")
	else
		return interp("A")
	end
end)
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- don't dirty registers
vim.keymap.set({"n", "x"}, "x", "\"_x")

vim.keymap.set("i", "<c-e>", "<c-o><c-e>")
vim.keymap.set("i", "<c-y>", "<c-o><c-y>")

-- readline
vim.keymap.set({"i", "c"}, "<c-a>", "<Home>")

-- Misc {{{2

vim.keymap.set({ "i", "s" }, "<c-r>!", [[<c-r>=system(input("!", "", "shellcmd"))<cr>]])

vim.keymap.set("n", "<c-g>", function()
	local msg = require "vimrc.git_blame".blame()
	if msg ~= nil then
		print(msg)
	end
end)

-- scroll window
vim.keymap.set({"n", "x"}, "<left>", "zh")
vim.keymap.set({"n", "x"}, "<down>", "<c-e>")
vim.keymap.set({"n", "x"}, "<up>", "<c-y>")
vim.keymap.set({"n", "x"}, "<right>", "zl")



-- Other Things {{{1

vim.g.loaded_netrwPlugin = true -- disable netrw

-- apply colorscheme patches
-- vim.cmd [[exec "doau <nomodeline> ColorScheme" g:colors_name]]

vim.g.mapleader = "\\" -- stop plugins from polluting our leader

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = augroup,
	desc = "autochdir",
	callback = function()
		if vim.o.buftype == "" then
			vim.cmd [[silent! lcd %:p:h]]
		end
	end,
})
