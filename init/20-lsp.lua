local lspconfig = require "lspconfig"
lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		capabilities = require "cmp_nvim_lsp".default_capabilities(),
		handlers = {
			["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					focusable = false
				}
			)
		},
	}
)

vim.api.nvim_create_user_command("LspDebug", function()
	vim.lsp.set_log_level(vim.log.levels.DEBUG)
end, {
	nargs = 0,
	desc = "vim.lsp.set_log_level(vim.log.levels.DEBUG)",
})


-------------------------------------------------------------------------------

lspconfig.pylsp.setup {
	cmd = {
		"nix", "shell", "nixpkgs#python3Packages.python-lsp-server", "-c",
		"pylsp",
	},
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
		"nix", "run", "nixpkgs#jdt-language-server", "--",
		"-Xms512M",
		"-Xmx1G",
		"-data", vim.env.JDTLS_WORKSPACE or "/tmp/jdtls-workspace",
	},
	root_dir = function(fname)
		return (
			lspconfig.util.find_git_ancestor(fname)
			or lspconfig.util.root_pattern("build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts", ".project", ".classpath")(fname)
			or lspconfig.util.root_pattern("build.gradle", "build.gradle.kts")
		)
	end,
}

lspconfig.gopls.setup {
	cmd = { "gopls", "-remote=auto" },
}

lspconfig.lua_ls.setup {
	cmd = {
		"nix", "run", "nixpkgs#lua-language-server", "--",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.list_extend({ "lua/?.lua", "lua/?/init.lua", }, vim.split(package.path, ";")),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
}

lspconfig.nil_ls.setup {
	cmd = {
		"nix", "run", "nixpkgs#nil", "--",
	},
}

local null_ls = require "null-ls"
null_ls.setup {
	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.shellcheck.with({
			command = function()
				if vim.fn.executable("shellcheck") > 0 then
					return "shellcheck"
				end

				local drv = nil
				local jobid = vim.fn.jobstart(
					{"nix", "build", "--no-link", "--json", "nixpkgs#shellcheck" },
					{
						stdout_buffered = true,
						on_stdout = function(chan_id, data, name)
							drv = vim.fn.json_decode(data)
						end,
					}
				)
				vim.fn.jobwait({ jobid })

				return drv[1].outputs.bin .. "/bin/shellcheck"
			end,
		}),
	},
}

