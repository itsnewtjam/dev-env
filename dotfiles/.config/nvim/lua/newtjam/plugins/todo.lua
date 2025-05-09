return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
  },
  keys = {
    {
      "<leader>pt",
      function()
        require("telescope._extensions.todo-comments").exports.todo({cwd = vim.loop.cwd() })
      end,
      "project todos"
    },
  }
}
