local M = {}

local qfid = nil

function M.qfid()
	if qfid == nil then
		vim.fn.setqflist({}, " ", {
			title = "vimrc.diagnostic",
		})
		qfid = vim.fn.getqflist({ all = true, nr = "$" }).id
	end
	return qfid
end

function M.update_qf_with_items(items)
	vim.fn.setqflist({}, "r", {
		id = M.qfid(),
		items = items,
		title = "vimrc.diagnostic",
	})
end

function M.load_qf()
	local qfnr = vim.fn.getqflist({ all = true, id = M.qfid() }).nr
	vim.cmd("silent " .. qfnr .. "chistory")
end

function M.setup(opt)
	opt = opt or {} -- doesn't do anything for now

	M.qfid()
	local au = vim.api.nvim_create_augroup("vimrc_diagnostic", {})
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = au,
		desc = "vimrc.diagnostic: update qf",
		callback = function()
			M.update_qf_with_items(vim.diagnostic.toqflist(vim.diagnostic.get()))
		end,
	})
end

return M
