return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gdo", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
		{ "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
		{ "<leader>gdh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
	},
}