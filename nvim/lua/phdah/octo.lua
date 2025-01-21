require("octo").setup({
    suppress_missing_scope = {projects_v2 = true},
    enable_builtin = true,
    mappings = {
        issue = {
            open_in_browser = {lhs = "<leader>bo", desc = "open PR in browser"}
        },
        pull_request = {
            open_in_browser = {lhs = "<leader>bo", desc = "open PR in browser"}
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
        vim.keymap.set("i", "@", "@<C-x><C-o>", {silent = true, buffer = true})
        vim.keymap.set("i", "#", "#<C-x><C-o>", {silent = true, buffer = true})
    end

})

