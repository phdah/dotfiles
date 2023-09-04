local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'pyright',
  'clangd',
  'jsonls',
  'yamlls',
  'bashls'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.set_preferences({
    suggest_lsp_servers = true,
})

-- Disable dependencies for autocomplete
lsp.set_preferences({
  manage_nvim_cmp = false,
  cmp_capabilities = false
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    signs = false,
})

-- Custom LSPs
local lspconfig = require('lspconfig')
lspconfig.metals.setup{
    root_dir = function (fname)
        return vim.fn.getcwd()
    end,
    settings = {
        metals = {
          quietLogs = true
        }
      },
      cmd = {"/usr/local/bin/metals-vim"},
      on_attach = function(client, bufnr)
end
}
