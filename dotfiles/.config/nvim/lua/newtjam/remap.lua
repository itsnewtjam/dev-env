vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ya", "<cmd>%y+<cr>")
vim.keymap.set("v", "<leader>ys", '"+y')

vim.keymap.set("v", "J", ":'<,'>move '>+1<CR>gv")
vim.keymap.set("v", "K", ":'<,'>move '<-2<CR>gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")

vim.keymap.set("n", "<leader><CR>", function()
  local info = vim.fn.getqflist({idx = 0, items = 0})
  local idx = info.idx
  local items = info.items

  if #items == 0 then
    return
  end

  table.remove(items, idx)
  vim.fn.setqflist(items, "r")

  if idx <= #items then
    vim.cmd("cc " .. idx)
  elseif #items > 0 then
    vim.cmd("cc " .. #items)
  else
    vim.notify("Quickfix empty")
  end
end)
