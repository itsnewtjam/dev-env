return {
  "folke/trouble.nvim",
  tag = "v3.6.0",
  opts = {
  },
  keys = {
    { "<leader>t", function() require("trouble").toggle("diagnostics") end, desc = "toggle trouble" },
  }
}
