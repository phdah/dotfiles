require("octo").setup({
    suppress_missing_scope = {projects_v2 = true},
    enable_builtin = true,
    mappings = {
        issue = {
            open_in_browser = {lhs = "<leader>bo", desc = "open PR in browser"}
        },
        pull_request = {
            open_in_browser = {lhs = "<leader>bo", desc = "open PR in browser"}
            -- Maybe create a PR on the repo to add this?
            -- Add the entry to mappings.lua
            -- resolve_thread = function()
            --     require("octo.commands").resolve_thread()
            -- end,
            -- then add default keymaps in the config.lua
            -- resolve_thread = { lhs = "<leader>rt", desc = "resolve the current thread" }
        }
    }

})

vim.treesitter.language.register('markdown', 'octo')

local auGroup = vim.api.nvim_create_augroup("nvim-octo-custom", {clear = true})
vim.api.nvim_create_autocmd("FileType", {
    group = auGroup,
    pattern = "octo",
    callback = function()
        vim.cmd("setlocal spell! spelllang=en_us")
        vim.api.nvim_set_keymap('n', '<leader>rt',
                                ':lua require("octo.commands").resolve_thread()<CR>',
                                {noremap = true, silent = true})
    end

})

