local util = require "lspconfig.util"

local bin_name = "isabelle"
local cmd = {
	bin_name,
	"vscode_server",
	-- https://isabelle-dev.sketis.net/source/isabelle/browse/default/src/Tools/VSCode/etc/options
	"-o", "vscode_unicode_symbols",
	"-o", "vscode_pide_extensions",
}

local function caret_update()
	vim.lsp.buf_notify(0, "PIDE/caret_update", {
		-- isabelle has its own format for this
		uri = vim.uri_from_bufnr(0),
		line = vim.fn.line(".") - 1,
		character = math.min(vim.fn.col("."), vim.fn.col("$") - 1), -- past-the-end breaks isabelle
		focus = true,
	})
end

return {
	default_config = {
		cmd = cmd,
		filetypes = { "isabelle" },
		single_file_support = true,
		root_dir = util.find_git_ancestor,

		on_init = function(client, result)
			-- TODO
		end,

		on_exit = function(code, signal, client_id)
			-- TODO
			print(code)
			print(signal)
			print(client_id)
		end,

		handlers = {
			["PIDE/dynamic_output"] = function(err, result, context, config)
				config = config or {}
				print(vim.inspect(result))
			end,
		}
	},
	commands = {
		IsabelleUpdate = {
			caret_update,
		},
	},
}
