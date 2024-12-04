return {
	{
		"voldikss/vim-floaterm",
		event = "VeryLazy",
	},
	{
		"h1ghl1kh7/simple-note.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("simple-note").setup({
				-- Optional Configurations
				notes_dir = "~/.notes/", -- default: '~/notes/'
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<c-space>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					["*"] = true,
				},
			})
		end,
	},
}
