return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
  -- stylua: ignore
  keys = {
    { "<leader>sn", "", desc = "+noice"},
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
  },
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 1000,
			render = "compact",
			stages = "static",
		},
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
		config = function()
			local status_ok, bufferline = pcall(require, "bufferline")
			if not status_ok then
				return
			end
			vim.opt.termguicolors = true
			bufferline.setup({
				options = {
					mode = "buffers",
					separator_style = "thin",
				},
			})
		end,
	},

	-- filename / icon + filename
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({ -- Optional, you don't have to run setup.
				groups = { -- table: default groups
					"Normal",
					"NormalNC",
					"Comment",
					"Constant",
					"Special",
					"Identifier",
					"Statement",
					"PreProc",
					"Type",
					"Underlined",
					"Todo",
					"String",
					"Function",
					"Conditional",
					"Repeat",
					"Operator",
					"Structure",
					"LineNr",
					"NonText",
					"SignColumn",
					"CursorLine",
					"CursorLineNr",
					"StatusLine",
					"StatusLineNC",
					"EndOfBuffer",
				},
				extra_groups = { "NeoTreeNormal", "NeoTreeNormalNC", "NormalFloat" }, -- table: additional groups that should be cleared
				exclude_groups = {}, -- table: groups you don't want to clear
			})
		end,
	},
	{
		"echasnovski/mini.icons",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},
	{
		"tadaa/vimade",
		-- default opts (you can partially set these or configure them however you like)
		opts = {
			-- Recipe can be any of 'default', 'minimalist', 'duo', and 'ripple'
			-- Set animate = true to enable animations on any recipe.
			-- See the docs for other config options.
			recipe = { "default", { animate = false } },
			ncmode = "buffers", -- use 'windows' to fade inactive windows
			fadelevel = 0.4, -- any value between 0 and 1. 0 is hidden and 1 is opaque.
			tint = {
				-- bg = {rgb={0,0,0}, intensity=0.3}, -- adds 30% black to background
				-- fg = {rgb={0,0,255}, intensity=0.3}, -- adds 30% blue to foreground
				-- fg = {rgb={120,120,120}, intensity=1}, -- all text will be gray
				-- sp = {rgb={255,0,0}, intensity=0.5}, -- adds 50% red to special characters
				-- you can also use functions for tint or any value part in the tint object
				-- to create window-specific configurations
				-- see the `Tinting` section of the README for more details.
			},

			-- Changes the real or theoretical background color. basebg can be used to give
			-- transparent terminals accurating dimming.  See the 'Preparing a transparent terminal'
			-- section in the README.md for more info.
			-- basebg = [23,23,23],
			basebg = "",
			-- prevent a window or buffer from being styled. You
			blocklist = {
				default = {
					highlights = {
						laststatus_3 = function(win, active)
							-- Global statusline, laststatus=3, is currently disabled as multiple windows take ownership
							-- of the StatusLine highlight (see #85).
							if vim.go.laststatus == 3 then
								-- you can also return tables (e.g. {'StatusLine', 'StatusLineNC'})
								return "StatusLine"
							end
						end,
						-- Exact highlight names are supported:
						-- 'WinSeparator',
						-- Lua patterns are supported, just put the text between / symbols:
						-- '/^StatusLine.*/' -- will match any highlight starting with "StatusLine"
					},
					buf_opts = { buftype = { "prompt" } },
					win_config = { relative = true },
					-- buf_name = {'name1','name2', name3'},
					-- buf_vars = { variable = {'match1', 'match2'} },
					-- win_opts = { option = {'match1', 'match2' } },
					-- win_vars = { variable = {'match1', 'match2'} },
				},
				-- any_rule_name1 = {
				--   buf_opts = {}
				-- },
				-- only_behind_float_windows = {
				--   buf_opts = function(win, current)
				--     if (win.win_config.relative == '')
				--       and (current and current.win_config.relative ~= '') then
				--         return false
				--     end
				--     return true
				--   end
				-- },
			},
			-- Link connects windows so that they style or unstyle together.
			-- Properties are matched against the active window. Same format as blocklist above
			link = {},
			groupdiff = true, -- links diffs so that they style together
			groupscrollbind = false, -- link scrollbound windows so that they style together.
			-- enable to bind to FocusGained and FocusLost events. This allows fading inactive
			-- tmux panes.
			enablefocusfading = false,
			-- Time in milliseconds before re-checking windows. This is only used when usecursorhold
			-- is set to false.
			checkinterval = 1000,
			-- enables cursorhold event instead of using an async timer.  This may make Vimade
			-- feel more performant in some scenarios. See h:updatetime.
			usecursorhold = false,
			-- when nohlcheck is disabled the highlight tree will always be recomputed. You may
			-- want to disable this if you have a plugin that creates dynamic highlights in
			-- inactive windows. 99% of the time you shouldn't need to change this value.
			nohlcheck = true,
		},
	},
}
