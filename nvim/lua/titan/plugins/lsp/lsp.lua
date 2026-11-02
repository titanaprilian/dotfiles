return {
	"hrsh7th/cmp-nvim-lsp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", opts = {} },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Capabilities for autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Apply capabilities to all LSPs
		vim.lsp.config("*", { capabilities = capabilities })

		-- gopls settings
		vim.lsp.config("gopls", {
			root_dir = function(bufnr, on_dir)
				if vim.fn.executable("go") == 0 then
					return
				end
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local clients = vim.lsp.get_clients({ name = "gopls" })
				if #clients > 0 and (fname:match("/pkg/mod/") or fname:match("/src/")) then
					return on_dir(clients[#clients].config.root_dir)
				end
				local root = vim.fs.root(fname, { "go.work", "go.mod", ".git" })
				on_dir(root or vim.fs.dirname(fname))
			end,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
					completeUnimported = true,
					usePlaceholders = true,
				},
			},
		})

		-- kotlin_language_server settings
		vim.lsp.config("kotlin_language_server", {
			init_options = {
				storagePath = vim.NIL,
			},
			root_markers = {
				"settings.gradle",
				"settings.gradle.kts",
				"build.gradle",
				"build.gradle.kts",
			},
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local root = vim.fs.root(fname, {
					"settings.gradle",
					"settings.gradle.kts",
					"build.gradle",
					"build.gradle.kts",
				})
				local res = root or vim.fs.dirname(fname)
				if on_dir then
					return on_dir(res)
				end
				return res
			end,
			settings = {
				kotlin = {
					compiler = {
						jvm = { target = "17" },
					},
					formatting = {
						formatter = "none",
					},
				},
			},
		})
		vim.lsp.enable("kotlin_language_server")

		-- Configure diagnostic appearance (enable virtual text for inline error display)
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 4,
			},
			float = {
				border = "rounded",
				source = "always",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
		-- Keymaps when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP keybindings",
			callback = function(event)
				local opts = { buffer = event.buf, silent = true }

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.name == "kotlin_language_server" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

				--------------------------------------------------------------------
				-- Other navigation
				--------------------------------------------------------------------
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

				--------------------------------------------------------------------
				-- Hover & Peek
				--------------------------------------------------------------------
				-- Lspsaga peek definition
				vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)

				--------------------------------------------------------------------
				-- LSP actions
				--------------------------------------------------------------------
				vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				--------------------------------------------------------------------
				-- Diagnostics
				--------------------------------------------------------------------
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			end,
		})
	end,
}
