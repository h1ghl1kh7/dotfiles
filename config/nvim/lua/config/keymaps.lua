local mapKey = require("utils.keyMapper").mapKey
local opts = { noremap = true, silent = true }

-- Diagnostics
mapKey("<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

mapKey("<c-p>", ":Neotree focus<cr>")

mapKey("<S-A-h>", ":FloatermToggle<CR>", "n")
mapKey("<S-A-h>", "<C-\\><C-n>:FloatermToggle<CR>", "t")
mapKey("<S-A-n>", "<C-\\><C-n>:FloatermNew<CR>", "t")
mapKey("<S-A-j>", "<C-\\><C-n>:FloatermNext<CR>", "t")
mapKey("<S-A-p>", "<C-\\><C-n>:FloatermNew python3<CR>", "t")

mapKey("<C-q>", "@q")

mapKey("<S-A-l>", ":SimpleNoteList<CR>")
mapKey("<S-A-c>", ":SimpleNoteCreate<CR>")

mapKey("<tab>", "<cmd>BufferLineCycleNext<CR>", "n")
mapKey("<s-tab>", "<cmd>BufferLineCyclePrev<CR>", "n")

mapKey("<C-W>m", ":WinShift<CR>")

mapKey("<leader>mp", "<cmd>MarkdownPreview<CR>", "n")
mapKey("<leader>mh", "<cmd>MDHeaders<CR>", "n")
mapKey("<leader>mc", "<cmd>MDHeadersCurrent<CR>", "n")

mapKey("<leader>du", "<cmd>w !dos2unix %<CR><cmd>e!<CR>", "n")

mapKey("<", "<gv", "v")
mapKey(">", ">gv", "v")

mapKey("<leader>tp", "<cmd>TypstPreview<CR>", "n")
