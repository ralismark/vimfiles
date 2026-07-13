lua <<EOF
function Starlark_includeexpr()
	local fname = vim.v.fname
	if vim.v.fname:match("^//") then
		local root = vim.fs.root(0, {"WORKSPACE", "MODULE.bazel"})
		if root then
			local file = fname:gsub(":", "/"):gsub("^/", root)
			if vim.uv.fs_stat(file) then
				return file
			end

			local dir = vim.fs.dirname(file)
			if vim.uv.fs_stat(dir) then
				return dir
			end
		end
	end

	return vim.v.fname
end
EOF

setlocal includeexpr=v:lua.Starlark_includeexpr()
setlocal isfname+=:

let b:undo_ftplugin = exists("b:undo_ftplugin") ? b:undo_ftplugin . '|' : ""
let b:undo_ftplugin .= 'setl includeexpr< isfname<'
