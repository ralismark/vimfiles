local lspconfig = require "lspconfig"

local k8s_version = "v1.31.1"

local builtin_resource_regex = {
  [[.*k8s.io$]],
  [[^apps$]],
  [[^batch$]],
  [[^autoscaling$]],
  [[^policy$]],
}

local function match_k8s(bufnr)

	-- adapted from https://github.com/cenk1cenk2/schema-companion.nvim/blob/3c4ae9c1b1a87c54f9ffdb1717fb6cfe909fed84/lua/schema-companion/matchers/kubernetes.lua

	local resource = {}

	for _, line in pairs(vim.api.nvim_buf_get_lines(bufnr, 0, 2, false)) do
		local _, _, group, version = line:find([[^apiVersion:%s*["']?([^%s"'/]*)/?([^%s"']*)]])
		local _, _, kind = line:find([[^kind:%s*["']?([^%s"'/]*)]])

		if group and group ~= "" then
			resource.group = group
		end
		if version and version ~= "" then
			resource.version = version
		end
		if kind and kind ~= "" then
			resource.kind = kind
		end

		if resource.group and resource.kind then
			break
		end
	end

	if not resource.kind or not resource.group then
		return nil
	end

	if not resource.version or #vim.tbl_filter(function(regex)
		return resource.group:match(regex)
	end, builtin_resource_regex) > 0 then
		-- builtin resource

    	local _, _, resource_group = resource.group:find([[^([^.]*)]])

		if resource.version then
			return ("https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/%s-standalone-strict/%s-%s-%s.json"):format(
				k8s_version,
				resource.kind:lower(),
				resource_group:lower(),
				resource.version:lower()
			)
		end

		return ("https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/%s-standalone-strict/%s-%s.json"):format(
			k8s_version,
			resource.kind:lower(),
			resource_group:lower()
		)
	end

	return ("https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/%s/%s_%s.json"):format(
		resource.group:lower(),
		resource.kind:lower(),
		resource.version:lower()
	)
end

-------------------------------------------------------------------------------

lspconfig.yamlls.setup {
	nix = { "nixpkgs#yaml-language-server" },
	settings = {
		yaml = {
			validate = true,
			completion = true,
			hover = true,
			-- disable the schema store
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = {
				["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
				["https://example.com"] = "example.yaml",
			},
		},
	},

	on_attach = function (client, bufnr)
		local function set_schema(schema)
			client.settings = vim.tbl_deep_extend("force", client.settings, {
				yaml = {
					schemas = {
						[schema] = vim.uri_from_bufnr(bufnr),
					},
				},
			})
			client.notify("workspace/didChangeConfiguration")
		end

		local schema

		schema = match_k8s(bufnr)
		if schema then
			set_schema(schema)
		end
	end,
}
