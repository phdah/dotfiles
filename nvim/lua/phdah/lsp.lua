---------------
-- Mason lsp --
---------------
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'ruff', 'clangd', 'jsonls', 'yamlls', 'bashls', 'gopls', 'jdtls'
    }
})

-- Setup all lsp with defaults
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
require('mason-lspconfig').setup_handlers({
    function(server_name)
        -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
        if server_name ~= 'jdtls' then
            lspconfig[server_name].setup({capabilities = lsp_capabilities})
        end
    end
})

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
            pythonPath = "python3"
        }
    }
}

-- Set up the lua-language-server
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                -- LuaJIT in the case of Neovim
                version = 'LuaJIT',
                path = vim.split(package.path, ';')
            },
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true
                }
            },
            telemetry = {enable = false}
        }
    }
})

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
    pattern = {"scala", "sbt"},
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
    -- Save the file first
    vim.cmd('silent! w')

    local filetype = vim.bo.filetype

    -- Run the corresponding formatter based on the filetype
    if filetype == 'python' then
        vim.cmd('silent! !ruff format % ' .. args)
    elseif filetype == "go" then
        vim.cmd('silent! !gofmt -w % ' .. args)
        -- Replace tabs with spaces (treesitter issue)
        vim.cmd('silent! %s/\\t/    /g')
    elseif filetype == 'sh' then
        vim.cmd('silent! !shfmt -w -i 4 -ci % ' .. args)
    elseif filetype == 'c' or filetype == 'cpp' or filetype == 'json' or filetype == 'java' then
        vim.cmd('silent! !clang-format -i % ' .. args)
    elseif filetype == 'lua' then
        vim.cmd('silent! !lua-format -i % ' .. args)
    elseif filetype == 'sql' then
        vim.cmd('silent! !sql-formatter --fix --config \'{\"tabWidth\": 4, \"linesBetweenQueries\": 2}\' --language postgresql % ' .. args)
    elseif filetype == 'markdown' then
        vim.cmd('silent! !prettier --print-width 80 --prose-wrap always --write % ' .. args)
    elseif filetype == 'terraform' then
        vim.cmd('silent! !terraform fmt % ' .. args)
    end
end

-- Create the :Lint command
vim.api.nvim_create_user_command('Lint', function(opts) lintFile(opts.args) end,
                                 {nargs = "*"})

