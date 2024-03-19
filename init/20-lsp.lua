local lspconfig = require "lspconfig"
lspconfig.util.default_config = vim.tbl_extend(
	"force",
	lspconfig.util.default_config,
	{
		capabilities = require "cmp_nvim_lsp".default_capabilities{
		},
		handlers = {
			["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					focusable = false
				}
			)
		},
	}
)

local has_nix = vim.fn.executable("nix")
local function setup(lsp)
	return function(cfg)
		-- extract cfg.nix
		local nix = cfg.nix
		cfg.nix = nil

		local nix_run = cfg.nix_run
		cfg.nix_run = nil

		local cmd = (cfg.cmd or lsp.document_config.default_config.cmd)

		-- replace cmd
		if vim.fn.executable(cmd[1]) ~= 0 then
			-- don't do anything, cmd is fine as is
		elseif has_nix then
			if nix ~= nil then
				nix = table.append(table.append({ "nix", "shell" }, nix), { "-c" })
				cfg.cmd = table.append(nix, cmd)
			elseif nix_run ~= nil then
				cfg.cmd = table.append({ "nix", "run", nix_run, "--" }, table.slice(cmd, 1))
			else
				return
			end
		else
			return
		end

		return lsp.setup(cfg)
	end
end

-------------------------------------------------------------------------------

setup(lspconfig.pylsp) {
	-- We wanna have the tools/etc be "globally" installed, as opposed to
	-- requiring them to be installed in each individual venv.
	--
	-- To make them recognise packages installed just for the project, we pass
	-- them the python executable

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

setup(lspconfig.rust_analyzer) {
}

setup(lspconfig.clangd) {
	nix = { "nixpkgs#clang-tools" },
}

setup(lspconfig.jdtls) {
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

setup(lspconfig.gopls) {
	nix = { "nixpkgs#gopls" },
	cmd = { "gopls", "-remote=auto" },
}

setup(lspconfig.lua_ls) {
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

setup(lspconfig.nil_ls) {
	nix = { "nixpkgs#nil" },
	settings = {
		["nil"] = {
			nix = {
				flake = {
					autoArchive = true,
				},
			},
		},
	},
}

setup(lspconfig.tsserver) {
	nix = { "nixpkgs#nodePackages.typescript-language-server" },
}

setup(lspconfig.cssls) {
	nix = { "nixpkgs#vscode-langservers-extracted" },
}

local null_ls = require "null-ls"
null_ls.setup {
	sources = {
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

