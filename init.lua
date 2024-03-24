--[[ init.d -------------------------------------------------------------------

This init.lua does not contain any customisation, but instead runs all files
under init/ in lexicographical order. Those files are prefixed with 2 numbers
for ordering:

00 -- global init
10 -- plugin configuration
20 -- LSP
30 -- Options
40 -- UI configuration
50 -- Mappings & editing configuration
60 -- Autocmds
70 -- Misc
80 -- (unused)
90 -- after init

--]]

if vim.g.vscode ~= nil then
	return -- config is wholly incompatible
end

local files = vim.fn.globpath(vim.fn.stdpath("config"), "init/*", false, true)
table.sort(files)
for _, file in ipairs(files) do
	vim.cmd.source(file)
end
