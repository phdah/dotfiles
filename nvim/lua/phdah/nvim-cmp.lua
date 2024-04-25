-- Limit the height of comletions window
vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 5

-- Setup
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)  -- Use LuaSnip's lsp_expand function
        end,
    },
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'rg' },
        }
    ),
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<Down>'] = cmp.mapping(
            cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}
        ),
        ['<Up>'] = cmp.mapping(
            cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}
        ),
        ['<C-e>'] = cmp.mapping(
            { i = cmp.mapping.close(), c = cmp.mapping.close() }
        ),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources(
        {
            { name = 'path' }
        },
        {
            { name = 'cmdline' }
        }
    ),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-----------------------------------------------
-- Commands to start and stop autocompletion --
-----------------------------------------------

vim.api.nvim_create_user_command('CmpStart', function()
    require('cmp').setup.buffer({ enabled = true })
end, {})

vim.api.nvim_create_user_command('CmpStop', function()
    require('cmp').setup.buffer({ enabled = false })
end, {})

----------------------------------
-- Auto completion for Dadbod-ui --
----------------------------------
cmp.setup.filetype({"sql", "mysql", "plsql"}, {
    sources = cmp.config.sources{
        { name = 'vim-dadbod-completion' }
    }
})

vim.g.completion_chain_complete_list = {
    sql = {{complete_items = {'vim-dadbod-completion'}}}
}
vim.g.completion_matching_strategy_list = {'exact', 'substring'}
vim.g.completion_matching_ignore_case = 1

