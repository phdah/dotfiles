local M = {}
-- Quickfix list
local function jumpToQuickfixEntry()
    local lineNumber = vim.fn.line('.')
    vim.cmd('cc ' .. lineNumber)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-j>', '', {
            noremap = true,
            silent = true,
            callback = jumpToQuickfixEntry
        })
        vim.api
            .nvim_buf_set_keymap(0, 'n', 'cl', ':cclose<CR>', {silent = true})
    end
})

M.set_git_root = function()
    local filetype = vim.bo.filetype
    local root = require('nvim-utils').Git.find_git_root()

    if filetype == 'python' then
        vim.fn.setenv("PYTHONPATH", root)
    end
end

return M
