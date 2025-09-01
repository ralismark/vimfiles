-- vim: set foldmethod=marker:

local luasnip = require "luasnip"
local cmp = require "cmp"

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

vim.api.nvim_create_user_command("W", function()
	vim.cmd [[
		w !pkexec tee %:p >/dev/null
		setl nomod
	]]
end, {
	nargs = 0,
	desc = "sudo write",
})

-- Multitools {{{1


local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- these can't be <expr> maps since inserting text is forbidden while evaluating the map

vim.keymap.set({ "i", "s" }, "<tab>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	elseif cmp.visible() then
		cmp.select_next_item()
	elseif has_words_before() then
		cmp.complete()
	else
		interp("<Tab>")
	end
end)

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(-1)
	elseif cmp.visible() then
		cmp.select_prev_item()
	else
		interp("<Tab>")
	end
end)

vim.keymap.set({ "i", "s"}, "<cr>", function()
	if cmp.get_selected_entry() ~= nil then
		cmp.confirm()
	elseif luasnip.in_snippet() and luasnip.jumpable() then
		luasnip.jump(1)
	else
		interp("<cr>")
	end
end)

vim.keymap.set({ "i", "s"}, "<s-cr>", function()
	if cmp.get_selected_entry() ~= nil then
		cmp.confirm()
	elseif luasnip.in_snippet() and luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		interp("<cr>")
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

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end)
vim.keymap.set({ "i", "s" }, "<c-h>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(-1)
	end
end)

vim.keymap.set({ "n", "x" }, "<s-return>", "@w")

-- vim.keymap.set("i", "<space>", function()
-- 	if cmp.visible() then
-- 		cmp.confirm()
-- 	end
-- 	interp("<space>")
-- end)

-- Better Defaults {{{1

-- :h default-binds
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "&", "<cmd>&&<cr>")

-- better binds
vim.keymap.set({ "n", "x" }, ";", ":")
vim.keymap.set({ "n", "x" }, ",", ";")
vim.keymap.set({ "n", "x" }, "'", "`")
vim.keymap.set("x", "&", [[<c-\><c-n><cmd>'<,'>&&<cr>]])
vim.keymap.set("x", "p", "P")

-- wrapping (logical lines)
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
vim.keymap.set({"n", "x"}, "X", "\"_d")
vim.keymap.set({"n", "x"}, "XX", "\"_dd")

vim.keymap.set("i", "<c-e>", "<c-o><c-e>")
vim.keymap.set("i", "<c-y>", "<c-o><c-y>")

-- readline
vim.keymap.set({"i", "c"}, "<c-a>", "<Home>")
vim.keymap.set({"i", "c"}, "", "<c-w>")
vim.keymap.set({"i", "c"}, "<c-bs>", "<c-w>")

-- Motions & Text Objects {{{1

-- skip over punctuation for w/e/b/ge
--
-- these don't apply to operator-pending mode, to make e.g. "dw" still delete to
-- end of word
--
-- TODO handle iskeyword/isident?
vim.keymap.set({"n", "x"}, "w", function() vim.fn.search([[\<\k\|\s\zs\S\|^]], "Wz") end)
vim.keymap.set({"n", "x"}, "e", function() vim.fn.search([[\k\>\|\S\s\|$]], "Wz") end)
vim.keymap.set({"n", "x"}, "b", function() vim.fn.search([[\<\k\|\s\zs\S]], "bW") end)
vim.keymap.set({"n", "x"}, "ge", function() vim.fn.search([[\k\>\|\S\s\|$]], "bW") end)

-- TODO v:count
vim.keymap.set({"n", "x", "o"}, "(", function()
	for _ = 1, vim.fn.max({1, vim.v.count}) do
		if vim.fn.virtcol(".") == 1 then
			vim.fn.search([[^\n\zs.\|\%^]], "bsWz")
		else
			local line = vim.fn.search([[\_$\%<.v\n.*\%.v\zs.]], "bsWz")
			if line == 0 then
				-- can't do this in the search since virtualedit
				return interp("gg")
			end
		end
	end
end)

-- TODO v:count
vim.keymap.set({"n", "x", "o"}, ")", function()
	for _ = 1, vim.fn.max({1, vim.v.count}) do
		if vim.fn.virtcol(".") == 1 then
			vim.fn.search([[.\+\n$]], "sWz")
		else
			local line = vim.fn.search([[\%.v..*\n.*\_$\%<.v]], "sWz")
			if line == 0 then
				-- can't do this in the search since virtualedit
				return interp("G")
			end
		end
	end
end)

-- make cursor go to column of other end by default
vim.keymap.set("v", "|", function()
	if vim.v.count == 0 then
		return interp(vim.fn.virtcol("v") .. "|")
	else
		return interp(vim.v.count .. "|")
	end
end)

local segment_regex = "\\C" .. table.concat({
	[[[A-Z]\@<![A-Z]\([A-Z]*[a-z]\@!\|[a-z]*\)]], -- UPPERCASE segment (also accounting for acronym within camelcase e.g. ABCFoo)
	[[[A-Za-z]\@<![a-z]\+]], -- lowercase segment
	[[[A-Z][a-z]*]], -- Capitalised segment
	[[\d\@<!\d\+]], -- numbers
	"[^[:keyword:][:space:]]", -- Symbols
	[[\_$]],
	[[\_^]],
}, "\\|")

local segment_end_regex = "\\C" .. table.concat({
	"$", -- end of line
	"[A-Z]\\zs[^A-Za-z]", -- UPPERCASE segment
	"[A-Z]\zs[A-Z][a-z]", -- UPPERCASE acryonym in camelCase
	"[a-z]\\zs[^a-z]", -- lowercase segment
	[[\d\zs\D]], -- numbers
}, "\\|")

-- TODO behave more sensibly when not within a segment
-- TODO operator is/as
-- TODO v:count

vim.keymap.set({"n", "x", "o"}, "s", function()
	for _ = 1, vim.fn.max({1, vim.v.count}) do
		vim.fn.search(segment_regex, "zW")
	end
end)
-- Misc {{{1

vim.keymap.set({ "i", "s" }, "<c-r>!", function()
	local cmd = vim.fn.input({
		prompt = "!",
		default = "",
		completion = "shellcmd",
	})
	local lines = vim.fn.systemlist(cmd)
	vim.api.nvim_put(lines, "c", true, true)
end)
vim.keymap.set({ "i", "s" }, "<c-r><c-d>", function()
	vim.api.nvim_put({ vim.fn.strftime("%Y-%m-%d") }, "c", false, true)
end)
vim.keymap.set({ "i", "s" }, "<c-r><c-p>", function()
	vim.api.nvim_put({ vim.fn.expand("%:p") }, "c", false, true)
end)

-- scroll window
vim.keymap.set({"n", "x"}, "<left>", "zh")
vim.keymap.set({"n", "x"}, "<down>", "<c-e>")
vim.keymap.set({"n", "x"}, "<up>", "<c-y>")
vim.keymap.set({"n", "x"}, "<right>", "zl")

vim.keymap.set({"i"}, "<c-l>", function()
	local parts = vim.fn.split(vim.o.commentstring, "%s", true)
	if #parts ~= 2 then
		return
	end
	vim.api.nvim_put({ parts[1] }, "c", false, true)
	vim.api.nvim_put({ parts[2] }, "b", false, false) -- <2024-04-05> Using b here is a bit of a hack but c doesn't work
end)

-- Git stuff
vim.keymap.set("n", "<c-g><c-g>", function()
	local msg = require "vimrc.git".blame()
	if msg ~= nil then
		print(msg)
	end
end)

vim.keymap.set("n", "<c-g><c-l>", function()
	local repo = require "vimrc.git".Repo()
	local url = repo:file_url()
	if url then
		print("Copied: " .. url)
		vim.fn.setreg("+", url)
	end
end)

vim.keymap.set("v", "<c-g><c-l>", function()
	local repo = require "vimrc.git".Repo()
	local url = repo:file_url()
	if url then
		print("Copied: " .. url)
		vim.fn.setreg("+", url)
	end
end)

vim.keymap.set("i", "<c-x><c-a>", function()
	cmp.complete {
		config = {
			sources = {
				{ name = "cody" },
			},
		}
	}
end)
