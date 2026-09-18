rc.lspsetup "basedpyright" {
	enable = false,

	nix = { "nixpkgs#basedpyright" },
	settings = {
		python = {
			pythonPath = vim.fn.exepath("python3"),
		},
		basedpyright = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,

				-- default diagnostic levels
				diagnosticSeverityOverrides = {
					reportUnusedCallResult = "none",
				},
			},
		},
	}
}

rc.lspsetup "pylsp" {
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

					exclude = {
						"/nix/store/*"
					}
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

rc.lspsetup "rust_analyzer" {
}

rc.lspsetup "clangd" {
	nix = { "nixpkgs#clang-tools" },
	cmd = {
		"clangd",
	},
	single_file_support = true,
}

rc.lspsetup {
	enabled = false,

	nix = { "nixpkgs#jdt-language-server" },
	cmd = {
		"jdtls",
		"-Xms512M",
		"-Xmx1G",
		"-data", vim.env.JDTLS_WORKSPACE or "/tmp/jdtls-workspace",
	},
	root_dir = function(fname)
		return (
			vim.fs.root(fname, ".git")
			or vim.fs.root(fname, {"build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts", ".project", ".classpath"})
			or vim.fs.root(fname, {"build.gradle", "build.gradle.kts"})
		)
	end,
}

rc.lspsetup "gopls" {
	nix = { "nixpkgs#gopls" },
	cmd = { "gopls", "-remote=auto" },
}

rc.lspsetup "lua_ls" {
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
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
}

rc.lspsetup "ts_ls" {
	nix = { "nixpkgs#typescript-language-server" },
	settings = {
	}
}

rc.lspsetup "cssls" {
	nix = { "nixpkgs#vscode-langservers-extracted" },
}

rc.lspsetup "jsonls" {
	nix = { "nixpkgs#vscode-langservers-extracted" },
	settings = {
		json = {
			schemas = {
			}
		}
	}
}

rc.lspsetup "bashls" {
	nix = {
		"nixpkgs#bash-language-server", "nixpkgs#shellcheck",
	},
}

rc.lspsetup "jsonnet_ls" {
	nix = { "nixpkgs#jsonnet-language-server" },
	settings = {
		formatting = {
			StringStyle = "double",
		},
	}
}

rc.lspsetup "nil_ls" {
	nix = { "nixpkgs#nil" },

	settings = {
		["nil"] = {
			formatting = {
				command = { "nix", "run", "-f", "<nixpkgs>", "nixfmt-rfc-style" },
			},
			nix = {
				maxMemoryMB = 512,
				flake = {
					autoArchive = true,
				},
			},
		}
	}
}

rc.lspsetup "vale_ls" {
	enable = false,

	nix = { "nixpkgs#vale-ls", "nixpkgs#vale" },

	filetypes = {
		"pandoc",
	},

	settings = {
		installVale = false,
	}
}
