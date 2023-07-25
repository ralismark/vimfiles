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
	nix = { "nixpkgs#python3Packages.python-lsp-server" },
	settings = {
		pyls = {
			plugins = {
				pylint = { enabled = true },
				yapf = { enabled = false },
			},
		},
	},
}

setup(lspconfig.rust_analyzer) {
}

setup(lspconfig.clangd) {
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

