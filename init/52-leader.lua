vim.g.mapleader = " "

vim.keymap.set("n", "<leader>", "<nop>")
vim.keymap.set("n", "<leader>r", [[<cmd>mode | syntax sync fromstart<cr>]])

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")

-- Toggles
local function cmp_toggle_source(name)
	-- get config
	local source = require "cmp.config".global.sources

	for _, v in ipairs(source) do
		if v.name == "DISABLED_" .. name then
			v.name = name
			return true
		elseif v.name == name then
			v.name = "DISABLED_" .. name
			return false
		end
	end
end
vim.keymap.set("n", "<leader>o", "<nop>")
vim.keymap.set("n", "<leader>ou", [[<cmd>UndotreeToggle<cr><c-w>999h]], { desc = "toggle UndoTree" })
vim.keymap.set("n", "<leader>og", [[<cmd>Goyo<cr>ze]], { desc = "toggle Goyo (focus mode)" })
vim.keymap.set("n", "<leader>ow", [[<cmd>set wrap! | set wrap?<cr>]], { desc = "toggle 'wrap'" })
vim.keymap.set("n", "<leader>os", [[<cmd>set spell! | set spell?<cr>]], { desc = "toggle 'spell'" })
vim.keymap.set("n", "<leader>on", [[<cmd>set relativenumber! | set relativenumber?<cr>]], { desc = "toggle 'relativenumber'" })
vim.keymap.set("n", "<leader>od", [[<cmd>if &diff | diffoff | else | diffthis | endif | set diff?<cr>]], { desc = "toggle 'diff'" })
vim.keymap.set("n", "<leader>oq", [[<cmd>if getqflist({"winid":0}).winid | cclose | else | botright copen | endif<cr>]], { desc = "open/close quickfix" })
vim.keymap.set("n", "<leader>ol", [[<cmd>if getloclist(0, {"winid":0}).winid | lclose | else | botright lopen | endif<cr>]], { desc = "open/close loclist" })
vim.keymap.set("n", "<leader>oa", function()
	print((cmp_toggle_source("cody") and "  " or "no") .. "aicomplete")
end, { desc = "toggle auto ai completion" })

-- Splits
vim.keymap.set("n", "<leader>s", "<nop>")
vim.keymap.set("n", "<leader>ss", "<c-w>s")
vim.keymap.set("n", "<leader>sv", "<c-w>v")
vim.keymap.set("n", "<leader>sh", "<cmd>aboveleft vertical new<cr>")
vim.keymap.set("n", "<leader>sl", "<cmd>belowright vertical new<cr>")
vim.keymap.set("n", "<leader>sj", "<cmd>belowright horizontal new<cr>")
vim.keymap.set("n", "<leader>sk", "<cmd>aboveleft horizontal new<cr>")

vim.keymap.set("n", "<leader>t", "<cmd>tab new<cr>")

-- Format
vim.keymap.set("n", "<leader>f", "<nop>")
vim.keymap.set("n", "<leader>fw", function()
	local view = vim.fn.winsaveview()
	vim.cmd("keepjumps keeppatterns %s/[\\x0d[:space:]]\\+$//e")
	vim.fn.winrestview(view)
end)
vim.keymap.set("n", "<leader>fl", function()
	vim.lsp.buf.format()
end)
vim.keymap.set("n", "<leader>fu", function()
	local reps = {
		["\\%x0d"] = "",
		["’"] = "'",
		["‘"] = "'",
		["“"] = '"',
		["”"] = '"',
	}
	for k, v in pairs(reps) do
		vim.cmd("keepjumps keeppatterns %s/" .. k .. "/" .. v .. "/ge")
	end
end)

-- Git
vim.keymap.set("n", "<leader>gb", function()
	local msg = require "vimrc.git".blame()
	if msg ~= nil then
		print(msg)
	end
end)


-- Open Files
vim.keymap.set("n", "<leader>e", "<nop>")
vim.keymap.set("n", "<leader>ev", "<cmd>e $MYVIMRC<cr>")
vim.keymap.set("n", "<leader>ef", "<cmd>e ~/src/github.com/ralismark/nixfiles/assets/fortunes<cr>")
vim.keymap.set("n", "<leader>et", "<cmd>term<cr>")

-- sometimes files come in pairs/groups, so this opens the "other" one
vim.keymap.set("n", "<leader>ee", function()
	local ext = vim.fn.expand("%:e")

	local function try_exts(exts)
		for _, newext in pairs(exts) do
			local candidate = vim.fn.expand("%:r") .. "." .. newext
			if vim.fn.filereadable(candidate) then
				vim.cmd.exit(candidate)
				return true
			end
		end
		return false
	end

	if ext == "h" or ext == "hpp" then
		if try_exts({ "c", "cpp" }) then
			return
		end
	elseif ext == "c" or ext == "cpp" then
		if try_exts({ "h", "hpp" }) then
			return
		end
	end
	vim.api.nvim_err_writeln("no alternate file found")
end)

-- misc
vim.keymap.set("n", "<leader>P", function()
	vim.cmd [[
		belowright vertical new
		wincmd W
		vertical resize 80
		set winfixwidth
	]]
end)
vim.keymap.set("n", "<leader>p", function()
	local count = 80
	if vim.v.count ~= 0 then
		count = vim.v.count
	end
	vim.cmd.wincmd { args = "|", count = count }
end)
