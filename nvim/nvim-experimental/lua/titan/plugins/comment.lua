return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- optional but highly recommended
  },
  config = function()
    -- Load Comment.nvim
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    comment.setup({
      -- Enables integration with Treesitter for more accurate comment types
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
