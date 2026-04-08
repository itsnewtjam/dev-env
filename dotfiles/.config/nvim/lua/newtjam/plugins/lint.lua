local linter_root_markers = {
  phpstan = { "phpstan.neon", "composer.json", ".git" },
}

return {
  "mfussenegger/nvim-lint",
  lazy = false,
  opts = {
    linters_by_ft = {
      php = { 'phpstan' },
    },
  },
  config = function(_, opts)
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        local lint = require("lint")

        lint.linters.phpstan = vim.tbl_deep_extend("force", lint.linters.phpstan, {
          args = {
            "analyze",
            "--level=6",
            "--no-progress",
            "--error-format=json",
          }
        })

        if vim.opt_local.modifiable:get() then
          local names = opts.linters_by_ft[vim.bo.filetype]

          if names == nil then return end

          for _, name in pairs(names) do
            local next = next

            if linter_root_markers[name] == nil or next(vim.fs.find(linter_root_markers[name], { upward = true })) then
              lint.try_lint(name)
            end
          end
        end
      end,
    })
  end,
}
