return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    {
      "<leader>fh",
      function()
        require('telescope.builtin').help_tags(require('telescope.themes').get_dropdown())
      end,
      desc = "find help"
    },
    {
      "<leader>pf",
      function()
        require('telescope.builtin').find_files({
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        })
      end,
      desc = "project files"
    },
    {
      "<leader>pg",
      function()
        require('telescope.builtin').git_files()
      end,
      desc = "project git files"
    },
    {
      "<leader>ps",
      function()
        require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "project search"
    },
    {
      "<leader>de",
      function()
        require('telescope.builtin').find_files({
          cwd = os.getenv('HOME') .. '/personal/dev-env',
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        })
      end,
      desc = "edit dev-env"
    },
  }
}
