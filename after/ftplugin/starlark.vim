lua <<EOF
function Starlark_includeexpr()
	local fname = vim.v.fname
	if fname:match("^//") then
		fname = fname:gsub(":", "/")
		local root = vim.fs.root(0, {"WORKSPACE", "MODULE.bazel"})
		if root then
			return fname:gsub("^/", root)
		end
	end

	return vim.v.fname
end
EOF

setlocal includeexpr=v:lua.Starlark_includeexpr()
setlocal isfname+=:

let b:undo_ftplugin = exists("b:undo_ftplugin") ? b:undo_ftplugin . '|' : ""
let b:undo_ftplugin .= 'setl includeexpr< isfname<'
