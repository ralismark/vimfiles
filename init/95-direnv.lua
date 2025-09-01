if vim.env.DIRENV_EXTRA_VIMRC then
	local ok, err = pcall(vim.cmd.source, vim.env.DIRENV_EXTRA_VIMRC)
	if not ok then
		vim.api.nvim_echo({{ err }}, true, { err = true })
	end
end
