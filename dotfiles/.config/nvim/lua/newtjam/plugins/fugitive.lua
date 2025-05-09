return {
  "tpope/vim-fugitive",
  lazy = false,
  keys = {
    { "<leader>gs", vim.cmd.Git, desc = "git status" },
    { "<leader>gp", function() vim.cmd.Git('push') end, desc = "git push" },
    {
      "<leader>ga",
      function()
        local name = vim.fn.input("Archive name: ")
        if name == "" then
          vim.api.nvim_echo({{"Archive cancelled"}}, true, {})
          return
        end
        vim.cmd.Git('archive HEAD --format=zip --output=./out/' .. name .. '.zip')
        vim.api.nvim_echo({{"Archive created: " .. name .. ".zip"}}, true, {})
      end,
      desc = "git archive"
    },
  }
}
