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
      "go",
      "gomod",
      "gowork",
      "gosum",
      "kotlin",
      "groovy",
      "xml",
    })

    -- enable autotagging (w/ nvim-ts-autotag plugin)
    require("nvim-ts-autotag").setup()

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")

    -- enable treesitter syntax highlighting
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("titan-treesitter-highlight", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
