return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    -- disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local nvimtree = require("nvim-tree")

    -- custom open behavior (fix for file exists issue)
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      -- default keymaps
      api.config.mappings.default_on_attach(bufnr)

      -- override <CR> behavior to force edit (not preview)
      vim.keymap.set("n", "<CR>", function()
        api.node.open.edit()
      end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
    end

    nvimtree.setup({
      on_attach = my_on_attach,
      view = {
        width = 40,
        relativenumber = true,
      },
      renderer = {
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = { enable = false },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
  end,
}
