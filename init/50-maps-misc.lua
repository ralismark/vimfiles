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

-- Multitools {{{1

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

-- Leader {{{1

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

-- Better Defaults {{{1

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

-- Misc {{{1

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



