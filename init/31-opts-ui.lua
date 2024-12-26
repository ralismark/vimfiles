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
vim.opt.smoothscroll = true

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
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
