vim.g.mapleader = " "

vim.keymap.set("n", "<leader>", "<nop>")
vim.keymap.set("n", "<leader>r", [[<cmd>mode | syntax sync fromstart<cr>]])

vim.keymap.set("n", "<leader>w", "<cmd>up<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")

-- Toggles
vim.keymap.set("n", "<leader>o", "<nop>")
vim.keymap.set("n", "<leader>ou", [[<cmd>UndotreeToggle<cr><c-w>999h]])
vim.keymap.set("n", "<leader>og", [[<cmd>Goyo<cr>ze]])
vim.keymap.set("n", "<leader>ow", [[<cmd>set wrap! | set wrap?<cr>]])
vim.keymap.set("n", "<leader>os", [[<cmd>set spell! | set spell?<cr>]])
vim.keymap.set("n", "<leader>on", [[<cmd>set relativenumber! | set relativenumber?<cr>]])
vim.keymap.set("n", "<leader>od", [[<cmd>if &diff | diffoff | else | diffthis | endif | set diff?<cr>]])
vim.keymap.set("n", "<leader>oq", [[<cmd>if getqflist({"winid":0}).winid | cclose | else | botright copen | endif<cr>]])
vim.keymap.set("n", "<leader>oc", [[<cmd>if getloclist(0, {"winid":0}).winid | lclose | else | botright lopen | endif<cr>]])
vim.keymap.set("n", "<leader>ol", function()
	if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
		vim.cmd("cclose")
	else
		require "vimrc.diagnostic".load_qf()
		vim.cmd("botright copen")
	end
end)

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

-- Open Files
vim.keymap.set("n", "<leader>e", "<nop>")
vim.keymap.set("n", "<leader>ev", "<cmd>e $MYVIMRC<cr>")
vim.keymap.set("n", "<leader>ef", "<cmd>e ~/src/github.com/ralismark/nixfiles/assets/fortunes<cr>")

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
vim.keymap.set("n", "<leader>m", "<cmd>Dispatch<cr>")
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
