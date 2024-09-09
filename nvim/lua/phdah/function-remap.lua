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

local set_git_root = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        return
    end

    local filetype = vim.bo.filetype
    if filetype == 'python' then
        vim.fn.setenv("PYTHONPATH", root)
    end
end

vim.api.nvim_create_user_command('SetGitRoot', function()
    set_git_root()
end, {})
