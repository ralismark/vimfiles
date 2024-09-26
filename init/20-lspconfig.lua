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

-- add nix= support, for wrapping cmd in nix shell/nix run
if vim.fn.executable("nix") == 1 then
	lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(cfg)
		if vim.fn.executable(cfg.cmd[1]) ~= 0 then
			-- cmd is runnable already, don't need to add nix
			return
		end

		if cfg.nix ~= nil then
			cfg.cmd = vim.iter({ "nix", "shell", cfg.nix, "-c", cfg.cmd }):flatten():totable()
		end
	end)
end
