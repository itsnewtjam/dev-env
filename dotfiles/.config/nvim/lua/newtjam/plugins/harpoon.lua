return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()
  end,
  keys = {
    {
      "<leader>a",
      function()
        require('harpoon'):list():add()
      end,
      "harpoon add"
    },
    {
      "<C-j>",
      function()
        require('harpoon'):list():next()
      end,
      "harpoon next"
    },
    {
      "<C-k>",
      function()
        require('harpoon'):list():prev()
      end,
      "harpoon prev"
    },
    {
      "<C-e>",
      function()
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
      end,
      "harpoon ui"
    },
  },
}
