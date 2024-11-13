local lspconfig = require "lspconfig"

lspconfig.pylsp.setup {
	-- We wanna have the tools/etc be "globally" installed, as opposed to
	-- requiring them to be installed in each individual venv. We can still use
	-- venvs by passing the venv python3 to pylsp.
	nix = {
		"--impure", "--expr", [[
			(import <nixpkgs> {}).python3.withPackages (ps: with ps; [
				flake8
				pyls-isort
				pylsp-mypy
				rope
				python-lsp-black
				python-lsp-server
			])
		]]
	},

	settings = {
		pylsp = {
			plugins = {
				jedi = {
					-- environment is either the path to the binary, or a folder
					-- that has ./bin/python
					environment = vim.fn.exepath("python3"),
					-- environment = vim.env.VIRTUAL_ENV,

					-- extra paths are effectively added to PYTHONPATH
					-- extra_paths = vim.fn.systemlist({ "python3", "-c", [[import site; print('\n'.join(site.getsitepackages()))]] }),
				},
				pylsp_mypy = {
					enabled = true,
					overrides = {
						-- use venv python if exists otherwise global
						"--python-executable", vim.fn.exepath("python3"), true,
					}
				},
				flake8 = {
					enabled = true,
					maxLineLength = 999, -- i never want this error
					perFileIgnores = {
						-- F401: unused import
						-- F403: star import
						"__init__.py:F401,F403",
					},
				},

				-- disable for flake8
				pycodestyle = { enabled = false },
				mccabe = { enabled = false },
				pyflakes = { enabled = false },
				-- disable default plugins
				autopep8 = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
}

lspconfig.rust_analyzer.setup {
}

lspconfig.clangd.setup {
	nix = { "nixpkgs#clang-tools" },
	cmd = {
		"clangd", "--log=verbose",
	},
	single_file_support = true,
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
	nix = { "nixpkgs#gopls" },
	cmd = { "gopls", "-remote=auto" },
}

lspconfig.lua_ls.setup {
	nix = { "nixpkgs#lua-language-server" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.list_extend({ "lua/?.lua", "lua/?/init.lua", }, vim.split(package.path, ";")),
				pathStrict = true,
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

lspconfig.ts_ls.setup {
	nix = { "nixpkgs#nodePackages.typescript-language-server" },
	settings = {
	}
}

lspconfig.cssls.setup {
	nix = { "nixpkgs#vscode-langservers-extracted" },
}

lspconfig.jsonls.setup {
	nix = { "nixpkgs#vscode-langservers-extracted" },
	settings = {
		json = {
			schemas = {
			}
		}
	}
}


lspconfig.bashls.setup {
	nix = {
		"nixpkgs#bash-language-server", "nixpkgs#shellcheck",
	},
}

lspconfig.jsonnet_ls.setup {
	nix = { "nixpkgs#jsonnet-language-server" },
}
