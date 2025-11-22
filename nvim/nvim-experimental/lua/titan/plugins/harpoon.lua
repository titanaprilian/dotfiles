return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- initialize harpoon
		harpoon:setup()

		-- Keymaps
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true, desc = "Harpoon" }

		keymap("n", "<leader>ha", function()
			harpoon:list():add()
			local filename = vim.fn.expand("%:t") -- get current file name
			vim.notify("Added " .. filename .. " to Harpoon list 🚀", vim.log.levels.INFO)
		end, { desc = "Add file to Harpoon list" })

		keymap("n", "<leader>hh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle Harpoon menu" })

		-- Quick navigation between marked files
		keymap("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Go to Harpoon file 1" })

		keymap("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Go to Harpoon file 2" })

		keymap("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Go to Harpoon file 3" })

		keymap("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Go to Harpoon file 4" })

		-- Optional: cycle through files
		keymap("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "Next Harpoon file" })

		keymap("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "Previous Harpoon file" })
	end,
}
