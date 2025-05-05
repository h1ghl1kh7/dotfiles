local keyMapper = require("utils.keyMapper").mapKey
local servers = {
	"lua_ls",
	"pylsp",
	"clangd",
	"cmake",
	"autotools_ls",
	"marksman",
	"lemminx",
	"jsonls",
	"dockerls",
	"docker_compose_language_service",
	"gopls",
	"ts_ls",
}

return {
	-- tools
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
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
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local server_configs = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				},
				pylsp = {
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = { enabled = false },
								pyflakes = { enabled = false },
								mccabe = { enabled = false },
								flake8 = { enabled = true },
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = true },
							format = { enable = true },
							validate = true,
						},
					},
				},
				gopls = {
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
							gofumpt = true,
						},
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							format = {
								indentSize = 2,
							},
							inlayHints = {
								includeInlayParameterNameHints = "all",
							},
						},
						javascript = {
							format = {
								indentSize = 2,
								semicolons = "remove",
							},
							inlayHints = {
								includeInlayParameterNameHints = "all",
							},
						},
						completions = {
							completeFunctionCalls = true,
						},
					},
					on_attach = function(client, bufnr)
						-- TypeScript 자동 임포트 설정
						client.server_capabilities.documentFormattingProvider = true
						-- 여기에 커스텀 키맵 추가 가능
					end,
				},
			}

			local servers_with_custom_settings = vim.tbl_keys(server_configs) -- 커스텀 설정이 있는 서버 목록

			for _, server in ipairs(servers) do
				if vim.tbl_contains(servers_with_custom_settings, server) then
					lspconfig[server].setup(vim.tbl_extend("force", {
						capabilities = capabilities,
					}, server_configs[server]))
				else
					lspconfig[server].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end
			end

			keyMapper("K", vim.lsp.buf.hover)
			keyMapper("<leader>r", vim.lsp.buf.rename)
			keyMapper("<leader>ca", vim.lsp.buf.code_action)

			vim.diagnostic.config({
				underline = true,
				signs = false,
				update_in_insert = false,
				severity_sort = false,
				virtual_text = false,
			})
			local ns = vim.api.nvim_create_namespace("CurlineDiag")
			vim.opt.updatetime = 100
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = args.buf,
						callback = function()
							pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
							local hi = { "Error", "Warn", "Info", "Hint" }
							local curline = vim.api.nvim_win_get_cursor(0)[1]
							local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
							local virt_texts = { { (" "):rep(4) } }
							for _, diag in ipairs(diagnostics) do
								virt_texts[#virt_texts + 1] = { diag.message, "Diagnostic" .. hi[diag.severity] }
							end
							vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
								virt_text = virt_texts,
								hl_mode = "combine",
							})
						end,
					})
				end,
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
					javascript = { "prettierd", "prettier" },
					typescript = { "prettierd", "prettier" },
					go = { "gofmt", "goimports" },
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
