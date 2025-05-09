return {
  "Mofiqul/dracula.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local dracula = require('dracula')
    dracula.setup({
      colors = {
        bg = "#282a36"
      },
      transparent_bg = true
    })
    vim.cmd.colorscheme 'dracula'
  end
}
