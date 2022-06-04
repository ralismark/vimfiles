-- vim: set foldmethod=marker:

-- Primary neovim initialisation
--
-- This can be renamed to init.lua if/when everything from
-- init.vim gets ported here

-- Plugins {{{1

-- LSP Config {{{2

local lspconfig = require "lspconfig"

lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		capabilities = require("cmp_nvim_lsp").update_capabilities(
			vim.lsp.protocol.make_client_capabilities()
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

lspconfig.pylsp.setup {
	settings = {
		pyls = {
			plugins = {
				pylint = { enabled = true },
				yapf = { enabled = false },
			},
		},
	},
}

lspconfig.rust_analyzer.setup {
}

lspconfig.clangd.setup {
}

lspconfig.jdtls.setup {
	cmd = {
		"jdtls",
	}
}

-- require "isabelle"
-- lspconfig.isabelle.setup {}

local null_ls = require "null-ls"
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.vale,
	},
})

require "lsp_signature".setup({
	floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
	doc_lines = 0,
	handler_opts = {
		border = "none",
	},

	hint_enable = false, -- virtual hint enable
	hint_prefix = "◇ ",
	hint_scheme = "LspParameterHint",
})

-- nvim-lightbulb {{{2

require "nvim-lightbulb".setup {
	autocmd = {
		enabled = true,
	},
}

vim.cmd([[
	augroup vimrc_lightbulb
		au!
		au CursorHold,CursorHoldI * lua require"nvim-lightbulb".update_lightbulb()
	augroup END
]])
