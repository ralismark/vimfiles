vim.loop.fs_unlink(vim.lsp.log.get_filename())

local function nixify_cmd(cmd, cfg_nix)
	if vim.fn.executable(cmd[1]) ~= 0 then
		return cmd
	end

	return vim.iter({ "nix", "shell", cfg_nix, "-c", cmd }):flatten():totable()
end

function rc.lspsetup(server)
	local has_nix = vim.fn.executable("nix") == 1

	return function(cfg)
		-- "nix": for wrapping cmd in nix shell/nix run
		if has_nix and cfg.nix then
			local cmd = cfg.cmd or vim.lsp.config[server].cmd

			if type(cmd) == "table" then
				cfg.cmd = nixify_cmd(cmd, cfg.nix)
			elseif type(cmd) == "function" then
				cfg.cmd = function(dispatchers, config)
					-- intercept vim.lsp.rpc.start call to nixifying cmd arg
					local vim_lsp_rpc_start = vim.lsp.rpc.start
					---@diagnostic disable-next-line: duplicate-set-field
					vim.lsp.rpc.start = function(cmd_inner, dispatchers_inner, extra_spawn_params)
						vim_lsp_rpc_start(nixify_cmd(cmd_inner, cfg.nix), dispatchers_inner, extra_spawn_params)
					end

					local ok, result = pcall(cmd, dispatchers, config)
					vim.lsp.rpc.start = vim_lsp_rpc_start
					if not ok then
						error(result)
					end
					return result
				end
			else
				print(server .. ": cmd unexpected type: " .. vim.inspect(cmd))
			end
		end

		vim.lsp.config(server, cfg)

		-- "enable": if set to false then don't enable
		if cfg.enable ~= false then
			vim.lsp.enable(server)
		end
	end
end
