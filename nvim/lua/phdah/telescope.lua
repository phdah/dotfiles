local actions = require("telescope.actions")
require("telescope").setup({
    path_display = {filename_first = {reverse_directories = false}},
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
                ["<C-k>"] = {"<esc>", type = "command"},
                ["<C-j>"] = actions.select_default
            },
            n = {
                ["q"] = actions.close,
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
                ["<C-j>"] = actions.select_default
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
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
