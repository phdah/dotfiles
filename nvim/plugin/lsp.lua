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
    virtual_text = true
})

