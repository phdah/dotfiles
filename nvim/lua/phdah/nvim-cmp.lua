-- NOTE: This should not be required in the init file,
-- it seems to be sourced automatically

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
        end,
    },
})

----------------------------------
-- Auto completion for Dadbod-ui --
----------------------------------

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"sql", "mysql", "plsql"},
    callback = function()
        require('cmp').setup.buffer({
            sources = {
                { name = 'vim-dadbod-completion' }
            }
        })
    end
})

-- vim.g.kris.completion = {}
vim.g.completion_chain_complete_list = {
    sql = {{complete_items = {'vim-dadbod-completion'}}}
}
vim.g.completion_matching_strategy_list = {'exact', 'substring'}
vim.g.completion_matching_ignore_case = 1

