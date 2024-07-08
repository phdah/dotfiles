require("telescope").setup({
    path_display = {filename_first = {reverse_directories = false}}
})

-- Load fzf-native search
require('telescope').load_extension('fzf')

-- Setup dynamic git root file finder
local M = {}
M.find_files_git = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        require("telescope").extensions.smart_open.smart_open()
        -- require('telescope.builtin').find_files()
    else
        require("telescope").extensions.smart_open.smart_open({cwd = root})
        -- require('telescope.builtin').find_files({cwd = root})
    end
end

M.live_grep_git = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        require('telescope.builtin').live_grep()
    else
        require('telescope.builtin').live_grep({cwd = root})
    end
end

M.grep_string_git = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        require('telescope.builtin').grep_string()
    else
        require('telescope.builtin').grep_string({cwd = root})
    end
end

return M
