vim.g.pdf_out = "/tmp/document.pdf"

local function open_pdf_out()
	if vim.g.pdf_out == nil then
		error("g:pdf_out is not defined")
	end
	vim.fn.jobstart({ "xdg-open", vim.g.pdf_out })
end

-- Try to convert an absolute path into its corresponding module name.
-- @param path string Path to resolve into a module
-- @return string|nil
local function lua_module_from_path(path)
	if path:sub(-4) ~= ".lua" then
		return nil
	end

	for _, rtp in ipairs(vim.api.nvim_list_runtime_paths()) do
		local root = rtp .. "/lua/"
		if path:sub(1, #root) == root then
			local rel = path:sub(#root + 1, -5):gsub("/", ".")
			return rel
		end
	end

	return nil
end

local execprg = {
	vim = function()
		vim.cmd.source("%")
	end,
	lua = function()
		local mod = lua_module_from_path(vim.fn.expand("%:p"))
		if mod ~= nil then
			print("Reloading " .. mod)
			require "plenary.reload".reload_module(mod, false)
			require(mod)
		else
			vim.cmd.luafile("%")
		end
	end,

	html = function()
		local path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "firefox-devedition", "--new-window", "file://" .. path })
	end,

	tex = function()
		local stem = vim.fn.expand("%:r")
		vim.fn.jobstart({ "xdg-open", stem .. ".pdf" })
	end,
	java = function()
		vim.cmd("botright split")
		vim.fn.termopen({"java", vim.fn.expand("%")})
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
