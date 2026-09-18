local logfile = vim.lsp.get_log_path()
vim.loop.fs_unlink(logfile)

-------------------------------------------------------------------------------

local lspconfig = require "lspconfig"

lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			-- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
			require "cmp_nvim_lsp".default_capabilities()
		),
		handlers = {
			["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					focusable = false
				}
			)
		},
	}
)

function rc.lspsetup(server)
	local has_nix = vim.fn.executable("nix") == 1

	return function(cfg)
		-- "enable": if set then don't setup
		if cfg.enable == false then
			return
		end

		-- "nix": for wrapping cmd in nix shell/nix run
		if has_nix and cfg.nix then
			local cmd = cfg.cmd or lspconfig[server].config_def.default_config.cmd
			if type(cmd) ~= "table" then
				print(server .. ": cmd is not a table")
			elseif vim.fn.executable(cmd[1]) ~= 0 then
				-- cmd is runnable already, don't need to add nix
			else
				cfg.cmd = vim.iter({ "nix", "shell", cfg.nix, "-c", cmd }):flatten():totable()
			end
		end

		lspconfig[server].setup(cfg)
	end
end
