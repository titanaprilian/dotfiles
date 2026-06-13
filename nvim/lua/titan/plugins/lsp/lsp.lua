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

		-- Keymaps when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP keybindings",
			callback = function(event)
				local opts = { buffer = event.buf, silent = true }

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
