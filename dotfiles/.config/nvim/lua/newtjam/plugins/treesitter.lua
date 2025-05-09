return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })()
  end,
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "json",
        "html",
        "php",
        "css",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
      },
      autotag = { enable = true },
      indent = { enable = true },
    })
  end,
}
