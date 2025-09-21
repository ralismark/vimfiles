vim.g.pdf_out = "/tmp/document.pdf"

local function open_pdf_out()
	if vim.g.pdf_out == nil then
		error("g:pdf_out is not defined")
	end
	vim.ui.open(vim.g.pdf_out)
end

-- Try to convert an absolute path into its corresponding module name.
---@param path string Path to resolve into a module
---@return string|nil
local function lua_module_from_path(path)
	if path:sub(-4) ~= ".lua" then
		return nil
	end

	for _, rtp in ipairs(vim.api.nvim_list_runtime_paths()) do
		local root = vim.uv.fs_realpath(rtp) .. "/lua/"
		if path:sub(1, #root) == root then
			local rel = path:sub(#root + 1, -5):gsub("/", ".")
			return rel
		end
	end

	return nil
end

local function open_browser()
	local path = vim.fn.expand("%:p")
	local browser = vim.env.BROWSER
	if not vim.fn.executable(browser or "") then
		vim.api.nvim_echo({ {"BROWSER="}, {vim.inspect(browser)}, {" is not executable"} }, true, { err = true })
	else
		vim.fn.jobstart({ browser, "--new-window", "file://" .. path })
	end
end

local execprg = {
	vim = function()
		vim.cmd.source("%:p")
	end,
	lua = function()
		local mod = lua_module_from_path(vim.fn.expand("%:p"))
		if mod ~= nil then
			print("Reloading " .. mod)
			require "plenary.reload".reload_module(mod)
			require(mod)
		else
			vim.cmd.luafile("%:p")
		end
	end,

	html = open_browser,
	svg = open_browser,

	tex = function()
		local stem = vim.fn.expand("%:r")
		vim.ui.open(stem .. ".pdf")
	end,
	java = function()
		vim.cmd("botright split")
		vim.fn.jobstart({"java", vim.fn.expand("%")}, {
			term = true,
		})
	end,

	rmd = open_pdf_out,
	pandoc = open_pdf_out,
	dot = open_pdf_out,
	mermaid = open_pdf_out,
}

local function exec_current()
	for ft in string.gmatch(vim.bo.ft, "[^.]+") do
		local com = execprg[ft]
		if com ~= nil and com ~= vim.NIL then
			com()
			return
		end
	end

	vim.api.nvim_echo({
		{ "No execprg found for ft='" .. vim.bo.ft .. "'", "ErrorMsg" }
	}, false, {})
end

vim.keymap.set("n", "<leader>x", exec_current)
