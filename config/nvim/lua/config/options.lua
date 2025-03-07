vim.g.mapleader = ","
vim.g.maplocalleader = ";" -- local leader
vim.g.lazyvim_picker = "auto"

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.g.floaterm_width = 0.95
vim.g.floaterm_height = 0.95
vim.g.floaterm_title = ""
vim.g.floaterm_shell = "/usr/bin/fish"
vim.g.floaterm_autoclose = 2

vim.g.mkdp_theme = 'light'

local opt = vim.opt

opt.number = true

opt.title = true
opt.autoindent = true
opt.smartindent = true
opt.hlsearch = true
opt.backup = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 3
opt.expandtab = true
opt.scrolloff = 10
opt.shell = "fish"
opt.backupskip = { "/tmp/*", "/private/tmp/*" }
opt.inccommand = "split"
opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.wrap = true -- No Wrap lines
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" }) -- Finding files - Search down into subfolders
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "cursor"
opt.mouse = "a"
opt.cursorline = true

opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
	opt.cmdheight = 0
end

opt.clipboard = "unnamedplus" -- clipboard setting

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])
