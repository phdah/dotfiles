---------------
-- Mason lsp --
---------------

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

-------------------
-- Python config --
-------------------

require("lspconfig").pyright.setup{
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            },
            pythonPath = "/opt/homebrew/bin/python3.10"
        }
    }
}

----------------
-- Metals lsp --
----------------

local metals_config = require("metals").bare_config()

-- Build in automatic setup dap adapter
metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
end


local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})

