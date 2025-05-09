return {
  "max397574/colortils.nvim",
  cmd = "Colortils",
  config = function()
    require("colortils").setup({
      color_preview =  "███ %s",
      mappings = {
        set_register_default_format = "<m-cr>",
        set_register_choose_format = "g<m-cr>",
        replace_default_format = "<cr>",
        replace_choose_format = "g<cr>",
      }
    })
  end,
  keys = {
    {"<leader>Cp", "<cmd>Colortils picker<cr>", desc = "colortils picker"},
    {"<leader>Cl", "<cmd>Colortils lighten<cr>", desc = "colortils lighten"},
    {"<leader>Cd", "<cmd>Colortils darken<cr>", desc = "colortils darken"},
  }
}
