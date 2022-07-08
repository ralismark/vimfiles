local M = {}

local qfid = 1
function M.qfid()
	if qfid == nil then
		vim.fn.setqflist({}, " ", {
			title = "Diagnostic",
		})
		qfid = vim.fn.getqflist({ all = true, nr = "$" }).id
	end
	return qfid
end

function M.update_qf_with_items(items)
	vim.fn.setqflist({}, "r", {
		id = M.qfid(),
		items = items,
		title = "Diagnostic",
	})
end

function M.update_qf()
	M.update_qf_with_items(vim.diagnostic.toqflist(vim.diagnostic.get()))
end

function M.load_qf()
	local qfnr = vim.fn.getqflist({ all = true, id = M.qfid() }).nr
	vim.cmd("silent " .. qfnr .. "chistory")
end

return M
