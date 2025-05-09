return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local newt_dracula = require("lualine.themes.dracula")
    newt_dracula.normal.c.bg = "#282a36"
    newt_dracula.insert.c.bg = "#282a36"
    newt_dracula.visual.c.bg = "#282a36"
    newt_dracula.replace.c.bg = "#282a36"
    newt_dracula.command.c.bg = "#282a36"
    newt_dracula.inactive.c.bg = "#282a36"
    lualine.setup {
      options = {
        theme = newt_dracula
      }
    }
  end,
}
