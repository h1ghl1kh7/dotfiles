local keymap = vim.keymap
local mapKey = require("utils.keyMapper").mapKey
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

mapKey("<c-p>", ":Neotree focus<cr>")

mapKey("<S-A-h>", ":FloatermToggle<CR>", "n")
mapKey("<S-A-h>", "<C-\\><C-n>:FloatermToggle<CR>", "t")
mapKey("<S-A-n>", "<C-\\><C-n>:FloatermNew<CR>", "t")
mapKey("<S-A-j>", "<C-\\><C-n>:FloatermNext<CR>", "t")
mapKey("<S-A-p>", "<C-\\><C-n>:FloatermNew python3<CR>", "t")

mapKey("<localleader>e", ":<C-u>MoltenEvaluateVisual<CR>gv", "v")
mapKey("<localleader>i", ":MoltenInit<CR>")
mapKey("<localleader>l", ":MoltenEvaluateLine<CR>")
mapKey("<localleader>r", ":MoltenReevaluateCell<CR>")
mapKey("<localleader>c", ":MoltenInterrupt<CR>")
mapKey("<localleader>d", ":MoltenDelete<CR>")
mapKey("<localleader>o", ":noautocmd MoltenEnterOutput<CR>")

mapKey("<C-q>", "@q")

mapKey("<S-A-l>", ":SimpleNoteList<CR>")
mapKey("<S-A-c>", ":SimpleNoteCreate<CR>")

mapKey("<C-W>m", ":WinShift<CR>")

mapKey("<leader>c.", ":cd %:h<CR>")

mapKey("<leader>mk", ":MarkdownPreview<CR>")

mapKey("J", "10j")
mapKey("K", "10k")
