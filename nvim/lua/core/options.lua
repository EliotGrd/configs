local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.smartindent = true

opt.smartcase = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

-- to always have n lignes at top while scrolling
opt.scrolloff = 8

opt.termguicolors = true
opt.background = "dark"

opt.clipboard:append("unnamedplus")
