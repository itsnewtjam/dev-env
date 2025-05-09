return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "L3M0N4D3/LuaSnip",
      "nvim-java/nvim-java",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      require("java").setup({})
      local cmp = require("cmp")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.css_variables.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })
      lspconfig.jdtls.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.marksman.setup({ capabilities = capabilities })
      lspconfig.phpactor.setup({
        capabilities = capabilities,
        init_options = {
          ["indexer.stub_paths"] = {
            os.getenv('HOME') .. "/ref/joomla/joomla-cms",
            os.getenv('HOME') .. "/ref/joomla/framework/vendor/joomla"
          },
        },
      })
      lspconfig.sqlls.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
          vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end)
          vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end)
          vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end)
          vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end)
       end,
      })

      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
      })

      vim.diagnostic.config({
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        }
      })
    end,
  }
}
