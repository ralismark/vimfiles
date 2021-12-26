local M = {}

local output_buf_handle = nil
function M.output_buf()
	if not output_buf_handle then
		output_buf_handle = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(output_buf_handle, "-OUTPUT-")
		vim.api.nvim_buf_set_lines(output_buf_handle, 0, -1, true, { "Isabelle is starting..." })
	end
	return output_buf_handle
end

function M.caret_update()
	if vim.o.ft ~= "isabelle" then
		return
	end

	return vim.lsp.buf_notify(0, "PIDE/caret_update", {
		uri = vim.uri_from_bufnr(),
		line = vim.fn.line(".") - 1,
		character = math.min(vim.fn.col("."), vim.fn.col("$") - 1), -- since past-the-end breaks isabelle
		focus = true,
	})
end

function M.open_output_buf()
	vim.cmd("split #" .. M.output_buf())
end

function M.indent(lnum)
	local ref_lnum = vim.fn.prevnonblank(lnum - 1)
	local ind = vim.fn.indent(ref_lnum)
	local ref_line = vim.fn.getline(ref_lnum)

	local function startswith(s)
		return ref_line:match("^%s*" .. s) ~= nil
	end

	-- end of proof
	if startswith("done")
		or startswith("oops")
		or startswith("sorry")
		or startswith("by")
		or startswith("qed")
		or startswith("apply_end")
	then
		return 0
	end

	-- start of proof
	if startswith("theorem")
		or startswith("lemma")
		or startswith("corollary")
		or startswith("definition")
	then
		return ind + vim.fn.shiftwidth()
	end

	return ind
end

require"lspconfig/configs".isabelle = {
	default_config = {
		cmd = { "isabelle", "vscode_server", "-o", "vscode_unicode_symbols=true", "-o", "vscode_pide_extensions" },
		filetypes = { "isabelle" },
		root_dir = require"lspconfig/util".path.dirname,
		on_init = function(client, result)
			vim.cmd([[
				augroup isabelle_lsp
					au!
					au CursorMoved,CursorMovedI * lua require'isabelle'.caret_update()
				augroup END
			]])
			M.caret_update()
			M.output_buf()
		end,
		on_exit = function(code, signal, client_id)
			vim.cmd([[
				augroup isabelle_lsp
					au!
				augroup END
			]])
		end,
		handlers = {
			["PIDE/dynamic_output"] = function(err, result, context, config)
				config = config or {}
				local lines = {}
				for line in result.content:gmatch('[^\n]+') do
					table.insert(lines, line)
				end

				vim.api.nvim_buf_set_lines(M.output_buf(), 0, -1, true, lines)
			end
		},
	},
}

-- plugin stuff
vim.cmd([[
	command! -bar IsabelleOpen lua require"isabelle".open_output_buf()
]])

return M
