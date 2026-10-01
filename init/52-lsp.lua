vim.api.nvim_create_user_command("LspFormat", function()
	vim.lsp.buf.format {
	}
end, {
	nargs = 0,
	desc = "vim.lsp.buf.format()",
})

vim.api.nvim_create_user_command("LspRename", function(params)
	vim.lsp.buf.rename(params.args)
end, {
	nargs = 1,
	desc = "vim.lsp.buf.rename(...)",
})

vim.api.nvim_create_user_command("LspDebug", function()
	vim.lsp.log.set_level(vim.log.levels.DEBUG)
end, {
	nargs = 0,
	desc = "vim.lsp.set_log_level(vim.log.levels.DEBUG)",
})

--[[

---@param item vim.quickfix.entry
local function jump_location(item)
	-- copied from get_locations in $VIMRUNTIME/lua/vim/lsp/buf.lua

	local from = vim.fn.getpos('.')
	from[1] = vim.api.nvim_get_current_buf()
	local tagname = vim.fn.expand('<cword>')
	local win = vim.api.nvim_get_current_win()

	local b = item.bufnr or vim.fn.bufadd(item.filename)

	-- Save position in jumplist
	vim.cmd("normal! m'")
	-- Push a new item into tagstack
	local tagstack = { { tagname = tagname, from = from } }
	vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, 't')

	vim.bo[b].buflisted = true
	local w = win
	vim.api.nvim_win_set_buf(w, b)
	vim.api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
	vim._with({ win = w }, function()
		-- Open folds under the cursor
		vim.cmd('normal! zv')
	end)
end


---@param opts vim.lsp.LocationOpts.OnList
local function on_list(opts)
	if #opts.items == 0 then
		return
	elseif #opts.items == 1 then
		jump_location(opts.items[1])
	else
		vim.ui.select(opts.items, {
			prompt = opts.title or "LSP",
			kind = "lsp-goto",
		format_item = function(item)
			return item.filename .. ":" .. item.lnum .. ": " .. (item.text or "")
		end,
		preview_item = function(item)
			if item.bufnr and vim.api.nvim_buf_is_loaded(item.bufnr) then
				return { buf = item.bufnr, pos = { item.lnum, item.col - 1 } }
			end
			local filename = item.filename or vim.api.nvim_buf_get_name(item.bufnr)
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(filename))
			vim.bo[buf].bufhidden = "wipe"
			local ft = vim.filetype.match({ filename = filename, buf = buf })
			if ft then
				vim.bo[buf].filetype = ft
			end
			return { buf = buf, pos = { item.lnum, item.col - 1 } }
		end,
		}, function(selected)
			if selected then
				jump_location(opts.items[1])
			end
		end)
	end
end
--]]

-- TODO add a timeout to these <2022-07-10>
vim.keymap.set("n", "gD", function() require "snacks".picker.lsp_declarations {} end, { desc = "vim.lsp.buf.declaration" })
vim.keymap.set("n", "gd", function() require "snacks".picker.lsp_definitions {} end, { desc = "vim.lsp.buf.definition" })
vim.keymap.set("n", "gi", function() require "snacks".picker.lsp_implementations {} end, { desc = "vim.lsp.buf.implementation" })
vim.keymap.set("n", "gm", function() require "snacks".picker.lsp_references {} end, { desc = "vim.lsp.buf.references" })
vim.keymap.set("n", "gt", function() require "snacks".picker.lsp_type_definitions {} end, { desc = "vim.lsp.buf.type_definition" })

vim.keymap.set("n", "K", function() vim.lsp.buf.hover { focusable = false } end, { desc = "vim.lsp.buf.hover" })
vim.keymap.set("n", "U", vim.lsp.buf.code_action, { desc = "vim.lsp.buf.code_action" })
