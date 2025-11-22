return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true, -- show git blame inline
			current_line_blame_opts = {
				delay = 500,
				virt_text_pos = "eol",
			},
		})

		-- Keymaps
		local keymap = vim.keymap.set
		keymap("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
		keymap("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
		keymap("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
		keymap("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		keymap("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
	end,
}
