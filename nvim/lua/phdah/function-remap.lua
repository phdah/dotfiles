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

