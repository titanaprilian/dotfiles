return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- Custom Harpoon v2 statusline component
    local function harpoon_component()
      local ok, harpoon = pcall(require, "harpoon")
      if not ok then
        return ""
      end

      local list = harpoon:list()
      local count = list:length()
      if count == 0 then
        return ""
      end

      local current_file = vim.fn.expand("%:p")
      local parts = {}

      for i = 1, count do
        local item = list:get(i)
        if item then
          local file_path = item.value
          local file_name = vim.fn.fnamemodify(file_path, ":t")
          if file_name == "" then
            file_name = "[No Name]"
          end

          -- Get full path for active check
          local full_path = vim.fn.fnamemodify(file_path, ":p")
          if current_file == full_path then
            table.insert(parts, string.format("󰛢 %d:%s", i, file_name))
          else
            table.insert(parts, string.format("○ %d:%s", i, file_name))
          end
        end
      end

      return table.concat(parts, "  ")
    end

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename" },
          {
            harpoon_component,
            color = { fg = colors.green, gui = "bold" },
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat", symbols = { unix = "" } },
          { "filetype" },
        },
      },
    })
  end,
}
