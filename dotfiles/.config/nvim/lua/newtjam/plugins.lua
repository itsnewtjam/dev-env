vim.pack.add({
  "https://github.com/Mofiqul/dracula.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/romus204/tree-sitter-manager.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/alvan/vim-closetag",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/tpope/vim-commentary",
  "https://github.com/artemave/workspace-diagnostics.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/max397574/colortils.nvim",
  "https://github.com/brenoprata10/nvim-highlight-colors",
  "https://github.com/tpope/vim-fugitive",
})

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)

require("dracula").setup({
  colors = {
    bg = "#282a36"
  },
  transparent_bg = true
})
vim.cmd.colorscheme("dracula")

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
    theme = newt_dracula,
  },
  sections = {
    lualine_x = {'encoding', 'lsp_status', 'filetype'},
  },
}

require("tree-sitter-manager").setup({
  ensure_installed = {
    "lua",
    "javascript",
    "typescript",
    "graphql",
    "json",
    "html",
    "php",
    "css",
  },
  auto_install = true,
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

local ts_builtin = require("telescope.builtin")
local ts_themes = require("telescope.themes")
vim.keymap.set("n", "<leader>fh", function()
  ts_builtin.help_tags(ts_themes.get_dropdown())
end)
vim.keymap.set("n", "<leader>pf", function()
  ts_builtin.find_files({
    find_command = {"rg", "--files", "--hidden", "--glob", "!**/.git/*"}
  })
end)
vim.keymap.set("n", "<leader>pg", ts_builtin.git_files)
vim.keymap.set("n", "<leader>ps", ts_builtin.live_grep)

vim.keymap.set("n", "<leader>pt", function()
  require("telescope._extensions.todo-comments").exports.todo({cwd = vim.loop.cwd()})
end)

vim.keymap.set("n", "<leader>t", function()
  require("trouble").toggle("diagnostics")
end)

require("nvim-surround").setup()

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

require("colortils").setup({
  color_preview =  "███ %s",
  mappings = {
    set_register_default_format = "<m-cr>",
    set_register_choose_format = "g<m-cr>",
    replace_default_format = "<cr>",
    replace_choose_format = "g<cr>",
  },
})
vim.keymap.set("n", "<leader>Cp", "<cmd>Colortils picker<cr>")
vim.keymap.set("n", "<leader>Cl", "<cmd>Colortils lighten<cr>")
vim.keymap.set("n", "<leader>Cd", "<cmd>Colortils darken<cr>")

require("nvim-highlight-colors").setup({
  render = "background",
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
