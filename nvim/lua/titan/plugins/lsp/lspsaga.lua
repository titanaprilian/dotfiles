return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	config = function()
		require("lspsaga").setup({})

		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.cmd("Lspsaga show_line_diagnostics ++unfocus")
				vim.o.updatetime = 300
			end,
		})

		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		vim.keymap.set("n", "gK", "<cmd>Lspsaga peek_definition<CR>", opts)

		vim.keymap.set(
			"n",
			"<leader>xf",
			"<cmd>Lspsaga show_line_diagnostics<CR>",
			{ desc = "Show diagnostics (focusable)" }
		)
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional but recommended
		"nvim-tree/nvim-web-devicons", -- for icons
	},
}
