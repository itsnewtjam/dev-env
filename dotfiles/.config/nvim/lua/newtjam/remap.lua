vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ya", "<cmd>%y+<cr>")
vim.keymap.set("v", "<leader>ys", '"+y')

vim.keymap.set("v", "J", ":'<,'>move '>+1<CR>gv")
vim.keymap.set("v", "K", ":'<,'>move '<-2<CR>gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")
