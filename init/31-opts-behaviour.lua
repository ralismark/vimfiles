vim.opt.shada = "!,'64,/16,<50,f1,h,s10"
vim.opt.fixeol = false -- don't make unnecessary changes
vim.opt.hidden = false -- drop buffers after they're closed
vim.opt.diffopt:append { "algorithm:patience", "indent-heuristic" }

if vim.fn.executable("rg") > 0 then
	vim.opt.grepprg = "rg --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m"
elseif vim.fn.executable("ag") > 0 then
	vim.opt.grepprg = "ag --nogroup --nocolor --column"
	vim.opt.grepformat = "%f:%l:%c%m"
else
	vim.opt.grepprg = "grep -rn"
	vim.opt.grepformat = "%f:%l:%m"
end

-- Shell things
-- TODO are these still relevant? <2023-02-24>
vim.opt.shell = vim.env.SHELL
--vim.opt.shellslash = true
vim.opt.shellpipe = "2>&1 | tee"

-- Automate/persistence
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.undofile = true
vim.opt.updatetime = 1000

-- Spelling
vim.opt.spelllang = "en_au,en_us"
vim.opt.spelloptions = "camel"
vim.opt.spellsuggest = "fast,8"

-- Completion
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.complete = ".,w,b,t"

-- Clipboard
vim.opt.clipboard = "unnamed,unnamedplus"
