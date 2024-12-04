local keyMapper = require("utils.keyMapper").mapKey
local servers = {
	"lua_ls",
	"pyright",
	"jedi_language_server",
	"pylsp",
	"clangd",
	"cmake",
	"autotools_ls",
	"marksman",
	"lemminx",
	"jsonls",
	"dockerls",
	"docker_compose_language_service",
}

return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = servers,
			})
		end,
	},
	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			for _, server in ipairs(servers) do
				lspconfig[server].setup({})
			end

			keyMapper("K", vim.lsp.buf.hover)
			keyMapper("<leader>r", vim.lsp.buf.rename)
			keyMapper("<leader>ca", vim.lsp.buf.code_action)

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = false,
					underline = false,
					signs = true,
				})

			vim.g.autoformat = false
		end,
	},
	{

		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },

					javascript = { { "prettierd", "prettier" } },
				},
				-- format_on_save = function(bufnr)
				-- 	if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				-- 		return
				-- 	end
				-- 	return { timeout_ms = 500, lsp_format = "fallback" }
				-- end,
			})
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })
			keyMapper("<leader>fo", ":Format<CR>")
		end,
	},
}
