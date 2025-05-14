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
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen,
				mappings = {
					i = {
						j = {
							-- These can all also be functions
							k = "<Esc>",
						},
					},
					c = {
						j = {
							k = "<Esc>",
						},
					},
					t = {
						j = {
							k = "<Esc><Esc>",
						},
					},
					v = {
						j = {
							k = "<Esc>",
						},
					},
					s = {
						j = {
							k = "<Esc>",
						},
					},
				},
			})
		end,
	},
	-- install with yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },

		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<localleader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
			{ "<localleader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
			{ "<localleader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
		},

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			-- ⚠️ This will only work if Telescope.nvim is installed
			-- The following are already the default values, no need to provide them if these are already the settings you want.
			session_lens = {
				-- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
				load_on_setup = true,
				previewer = false,
				mappings = {
					-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
					copy_session = { "i", "<C-Y>" },
				},
				-- Can also set some Telescope picker options
				-- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
				theme_conf = {
					border = true,
					-- layout_config = {
					--   width = 0.8, -- Can set width and height as percent of window
					--   height = 0.5,
					-- },
				},
			},
		},
	},
	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "1.*",
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
	},
}
