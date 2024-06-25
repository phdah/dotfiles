---------------
-- Mason lsp --
---------------
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'pyright', 'clangd', 'jsonls', 'yamlls', 'bashls', 'gopls'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.set_preferences({suggest_lsp_servers = true})

-- Disable dependencies for autocomplete
lsp.set_preferences({manage_nvim_cmp = false, cmp_capabilities = false})

lsp.setup()

vim.diagnostic.config({virtual_text = true, signs = false})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup {
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

-- lspconfig.gopls.setup({
--     root_dir = util.root_pattern("go.work", "go.mod", ".git"),
-- })

----------------
-- Metals lsp --
----------------

local metals_config = require("metals").bare_config()

-- Build in automatic setup dap adapter
metals_config.on_attach =
    function(client, bufnr) require("metals").setup_dap() end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals",
                                                      {clear = true})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"scala", "sbt", "java"},
    callback = function()
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group
})

----------------
-- Formatters --
----------------
-- Function to set the lint command for filetype
local function lintFile(args)
    local filetype = vim.bo.filetype
    if filetype == 'python' then
        vim.cmd('!autopep8 --in-place --aggressive --aggressive % ' .. args)
    elseif filetype == 'sh' then
        vim.cmd('!shfmt -w -i 4 -ci % ' .. args)
    elseif filetype == 'c' or filetype == 'cpp' or filetype == 'json' or
        filetype == 'java' then
        vim.cmd(
            '!clang-format -i % -style="{BasedOnStyle: Google, IndentWidth: 4, UseTab: Never}" ' ..
                args)
    elseif filetype == 'lua' then
        vim.cmd("!lua-format -i % " .. args)
    end
end

-- Create the :Lint command
vim.api.nvim_create_user_command('Lint', function(opts) lintFile(opts.args) end,
                                 {nargs = "*"})

