vim.g.man_hardwrap = false
vim.g.loaded_netrwPlugin = true -- disable netrw

-- UI/Editor {{{1

vim.opt.timeout = false
vim.opt.matchpairs:append("<:>")
vim.opt.lazyredraw = true
vim.opt.shortmess = "nxcIT"

-- splits
vim.opt.splitright = true

-- Status line
vim.opt.laststatus = 2
vim.opt.showmode = true
vim.opt.showtabline = 1
vim.opt.showcmd = true

-- Scrolling
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8

-- Completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.complete = ".,w,b,t"
vim.opt.completeopt = "menu,menuone,noinsert,noselect"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Replacing stuff
vim.opt.inccommand = "nosplit"

-- No bells/flash
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.belloff = "all"

-- Conceal
vim.opt.conceallevel = 1
vim.opt.concealcursor = ""

-- Hidden chars
vim.opt.list = true
vim.opt.listchars = "tab:│ ,extends:›,precedes:‹,nbsp:⎵,trail:∙"
vim.opt.fillchars = "eob: ,fold:─,stl: ,stlnc: ,diff:-,foldopen:╒,foldclose:═"

-- Line wrapping
vim.opt.wrap = false -- toggle with <leader>ow
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- Folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 999 -- open everything initially

-- Mouse
vim.opt.mouse = "a"

-- c-a and c-x
vim.opt.nrformats = "alpha,unsigned"

-- Key over lines
vim.opt.backspace = "indent,eol,start,nostop"
vim.opt.whichwrap = "b,s,<,>,[,]"

-- Allow cursor to go anywhere in visual block mode
vim.opt.virtualedit = "block"

-- Gutter
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "number"

-- Behaviour {{{1

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
vim.opt.shellslash = true
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

