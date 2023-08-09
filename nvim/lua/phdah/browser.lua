-- Open vim browser
_G.nvim_FilesGitRoot = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root == 'fatal: not a git repository (or any of the parent directories): .git' then
        vim.cmd('Files')
    else
        vim.cmd('Files ' .. root)
    end
end

