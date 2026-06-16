return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- configure treesitter
    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install({
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
    })

    -- enable autotagging (w/ nvim-ts-autotag plugin)
    require("nvim-ts-autotag").setup()

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")
  end,
}
