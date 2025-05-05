
-- sync with system clipboard on focus
vim.api.nvim_create_autocmd({ "FocusGained" }, {
	pattern = { "*" },
	command = [[call setreg("@", getreg("+"))]],
})

-- sync with system clipboard on focus
vim.api.nvim_create_autocmd({ "FocusLost" }, {
	pattern = { "*" },
	command = [[call setreg("+", getreg("@"))]],
})

vim.api.nvim_exec(
	[[
  autocmd TermOpen * tnoremap <buffer> <C-l> <C-l>
]],
	false
)

vim.api.nvim_exec(
	[[
  autocmd TermOpen * tnoremap <buffer> <C-k> <C-k>
]],
	false
)

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.sage"},
  callback = function()
    vim.bo.filetype = "python"
  end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.typ"},
  callback = function()
    vim.bo.filetype = "typst"
  end
})
